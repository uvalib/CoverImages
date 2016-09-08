class ScraperServices::Itunes < ScraperServices::Base

  ITUNES_URL = 'https://itunes.apple.com/search'

  def self.process cover_image
    search_term = CGI.escape("#{cover_image.album_name}")
    params = {
      term: search_term,
      media: 'music',
      limit: 5
    }

    response = HTTParty.get( ITUNES_URL,
                           query: params)

    raise 'iTunes requires that their images are used a promo material only'

  end
end
