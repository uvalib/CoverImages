class ScraperServices::OpenLibrary < ScraperServices::Base

  BASE_URL = 'http://covers.openLibrary.org'

  def self.process cover_image

    usable_ids = cover_image.present_ids.except('upc')
    unless usable_ids.any?
      cover_image.status = 'not_found'
      return cover_image
    end

    usable_ids.each do |id_name, id_value|
      response = HTTParty.get("#{BASE_URL}/b/#{id_name}/#{id_value}.json")

      if response.code == 200
        body = JSON.parse(response.body)

        cover_image.image = URI.parse(URI.encode(body['source_url']))
        cover_image.status = 'processed'
        cover_image.response_data = body
        break
      end

    end

    cover_image.service_name = 'openlibrary.org'
    cover_image
  end

end
