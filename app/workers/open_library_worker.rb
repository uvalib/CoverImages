class OpenLibraryWorker < ApplicationWorker
  sidekiq_options throttle: { threshold: 2, period: 1.second }, retry: false

  BASE_URL = 'http://covers.openLibrary.org'

  def perform cover_image_id
    begin
    @cover_image = CoverImage.find cover_image_id

    available_ids = @cover_image.present_ids.except('upc')
    unless available_ids.any?
      @cover_image.status = 'not_found'
      @cover_image.service_name = 'openlibrary.org'
      @cover_image.save
      #end of the line
      return
    end

    available_ids.each do |id_name, id_value|
      image_url = "#{BASE_URL}/b/#{id_name}/#{id_value}.jpg?default=false"

      begin
        @cover_image.image = image_url
        @cover_image.response_data = image_url
        @cover_image.service_name = 'openlibrary.org'

        save_if_found
        return

      rescue OpenURI::HTTPError => e
        # catch missing images and continue to loop over available ids
      end
      @cover_image.image = nil
      sleep(1)
    end

    save_if_found

    rescue StandardError => e
      @cover_image.update status: 'error'
      #end of the line
      raise e
    end
  end

end
