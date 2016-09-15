class OpenLibraryWorker < ApplicationWorker
  sidekiq_options throttle: { threshold: 2, period: 1.second }, retry: false

  BASE_URL = 'http://covers.openLibrary.org'

  def perform cover_image_id
    begin
    @cover_image = CoverImage.find cover_image_id

    usable_ids = @cover_image.present_ids.except('upc')
    unless usable_ids.any?
      @cover_image.status = 'not_found'
      @cover_image.service_name = 'openlibrary.org'
      @cover_image.save
      #end of the line
      return
    end

    usable_ids.each do |id_name, id_value|
      response = HTTParty.get("#{BASE_URL}/b/#{id_name}/#{id_value}.json")

      if response.code == 200
        body = JSON.parse(response.body)

        @cover_image.image = URI.parse(URI.encode(body['source_url']))
        @cover_image.response_data = body
        break
      end
    end

    @cover_image.service_name = 'openlibrary.org'
    save_if_found

    rescue StandardError => e
      @cover_image.update status: 'error'
      #end of the line
      raise e
    end
  end

end
