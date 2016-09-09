class ScraperServices::Google < ScraperServices::Base

  BASE_URL = 'https://books.google.com/books'.freeze

  # required by google, doesnt matter, needs to be consistent
  CALLBACK_LENGTH = 2

  def self.process cover_image
    begin
    bibkeys = ''
    CoverImage::IDENTIFIERS.without('upc').each do |id_type|
      next unless id = cover_image.send(id_type)
      bibkeys += ',' unless bibkeys.empty?
      bibkeys += "#{id_type.upcase}:#{id.gsub("\s+", '')}"
    end
    params = {
      bibkeys: bibkeys,
      jscmd: 'viewapi',
      callback: 'a' * CALLBACK_LENGTH
    }
    response = HTTParty.get(BASE_URL,
                            query: params
                           ).parsed_response
    # Strip off method name and closing ');' in response
    response = JSON.parse(response[(CALLBACK_LENGTH+1)..-3])
    response.each do |key, val|
      if  val['thumbnail_url'].present?
        # dont curl the corner of the book
        image_url = val['thumbnail_url'].gsub('&edge=curl','')
        cover_image.image = URI.parse(image_url)
        cover_image.status = 'processed'
        break
      end
    end
    cover_image.response_data = response

    rescue StandardError => e
        cover_image.update status: 'error'
        raise e
    end

  end
end
