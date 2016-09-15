class MusicBrainzWorker < ApplicationWorker
  sidekiq_options throttle: {threshold: 5, period: 1.second, retry: false}

  SEARCH_URL = 'http://musicbrainz.org/ws/2/release'.freeze
  COVER_ART_URL = '//coverartarchive.org/release'.freeze

  def perform cover_image_id
    begin
    @cover_image = CoverImage.find cover_image_id

    # first get the mbid if last_fm didnt provide one
    if @cover_image.mbid || get_mbid
      #then the cover image for that mbid
      get_cover_image
    end

    @cover_image.service_name = 'Music Brainz'
    save_if_found


    rescue StandardError => e
      @cover_image.update status: 'error', response_data: e

      raise e
    end
  end

  private

  def get_mbid
    params = {query: "release:\"#{@cover_image.album_name}\"",
      artist: @cover_image.artist_name,
      barcode: @cover_image.upc,
      fmt: 'json'
    }
    params.delete_if { |k, v| v.nil? || v.empty? }

    response = HTTParty.
      get(SEARCH_URL,
          query: params,
          headers: { "User-Agent" => 'VirgoCoverImages/1.0 (naw4t@virginia.edu)' }
         ).parsed_response


    release = response['releases'].first
    if release.nil?
      @cover_image.update status: 'not_found'
      return
    end


    r_title = release['title']
    r_artist = release.dig('artist-credit', 0, 'artist', 'name')

    # Is the returned artist name in the provided name
    #artist_matched = r_artist.split.any? {|w| @cover_image.artist_name.downcase.include? w.downcase}

    if  release['id']
      @cover_image.mbid = release['id']
      @cover_image.response_data = release
      return true
    else
      return false
    end
  end

  def get_cover_image
    response = HTTParty.get("#{COVER_ART_URL}/#{@cover_image.mbid}")

    case response.code
    when 404
      @cover_image.status = 'not_found'
    when 503
      @cover_image.status = 'error'
      @cover_image.response_data = 'Rate limit exceeded.'
    else
      url = response.parsed_response['images'].find{|img| img['front']}.try "['image']"
      if url
        @cover_image.image = URI.parse(url)
      else
        @cover_image.status = 'not_found'
      end
    end
  end
end
