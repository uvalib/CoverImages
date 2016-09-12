class ScraperServices::MusicBrainz < ScraperServices::Base

  SEARCH_URL = 'http://musicbrainz.org/ws/2/release'.freeze
  RELEASE_URL = 'http://musicbrainz.org/ws/2/release'.freeze

  # Only gets the mbid for now. Not used because last_fm gets the cover image in one step.
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

    cover_image.mbid = mbid
    cover_image.service_name = 'Music Brainz'

  end
end
