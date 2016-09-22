class LastFMWorker < ApplicationWorker
  sidekiq_options throttle: { threshold: 5, period: 1.second }, retry: false

  ALBUM_INFO_URL = 'http://ws.audioscrobbler.com/2.0/'.freeze
  HEADERS = { "User-Agent" => ENV['EXTERNAL_API_USER_AGENT'] }.freeze

  def perform cover_image_id
    begin

    @cover_image = CoverImage.find cover_image_id

    params = {
      method:   'album.getinfo',
      api_key:  ENV['LAST_FM_KEY'],
      mbid:     @cover_image.mbid,
      artist:   @cover_image.artist_name,
      album:    @cover_image.album_name,
      format:   'json'
    }
    response = HTTParty.get(ALBUM_INFO_URL,
                            query: params,
                            headers: HEADERS
                           ).parsed_response


    album = response['album']

    # check if the album name matches
    if album && @cover_image.artist_name.downcase.include?(album['artist'].downcase)
      @cover_image.mbid = album['mbid']

      image_url = album['image'].find do |size_link|
        size_link['size'] == 'large'
      end['#text']

      if image_url.present?
        @cover_image.image = URI.parse(image_url)
        @cover_image.status = 'processed'
      else
        @cover_image.status = 'not_found'
      end

    else
      @cover_image.status = 'not_found'

    end

    @cover_image.response_data = response
    @cover_image.service_name = 'last.fm'

    save_if_found


    rescue StandardError => e
      @cover_image.update(status: 'error', response_data: e)

      raise e
    end
  end
end
