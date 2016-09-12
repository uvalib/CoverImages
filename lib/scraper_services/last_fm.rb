class ScraperServices::LastFM < ScraperServices::Base
  ALBUM_INFO_URL = 'http://ws.audioscrobbler.com/2.0/'.freeze
  HEADERS = { "User-Agent" => 'VirgoCoverImages/1.0 (naw4t@virginia.edu)' }.freeze

  def self.process cover_image
    params = {
      method: 'album.getinfo',
      api_key: '***REMOVED***',
      artist: cover_image.artist_name,
      album: cover_image.album_name,
      format: 'json'
    }
    response = HTTParty.get(ALBUM_INFO_URL,
                            query: params,
                            headers: HEADERS
                           ).parsed_response


    album = response['album']
    if album && album['artist'].downcase.include?(cover_image.artist_name.downcase)
      cover_image.mbid = album['mbid']
      image_url = album['image'].find do |size_link|
        size_link['size'] == 'large'
      end['#text']

      if image_url.present?
        cover_image.image = URI.parse(image_url)
        cover_image.status = 'processed'
      else
        cover_image.status = 'not_found'
      end

    else
      cover_image.status = 'not_found'

    end
    cover_image.response_data = response
    cover_image.service_name = 'last.fm'

  end
end
