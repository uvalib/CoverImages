class ScraperServices::MusicBrainz < ScraperServices::Base

  SEARCH_URL = 'http://musicbrainz.org/ws/2/release'.freeze
  RELEASE_URL = 'http://musicbrainz.org/ws/2/release'.freeze

  def self.process cover_image
    params = {query: "release:\"#{cover_image.album_name}\"",
      artist: cover_image.artist_name,
      barcode: cover_image.upc
    }
    params.delete_if { |k, v| v.empty? }

    response = HTTParty.
      get(BASE_URL,
          query: params,
          headers: { "User-Agent" => 'VirgoCoverImages/1.0 (naw4t@virginia.edu)' }
         )

    release = response['metadata']['release_list']['release'].first
    r_title = release['title']
    r_artist = release.first['artist_credit']['name_credit']['artist']['name']

    mbid = release['id']

    cover_image.update mbid: mbid

  end
end
