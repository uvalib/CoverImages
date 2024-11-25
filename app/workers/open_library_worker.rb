# OpenLibrary Worker
class OpenLibraryWorker < ApplicationWorker
  sidekiq_options throttle: { threshold: 2, period: 1.second }, retry: false

  BASE_URL = 'http://covers.openLibrary.org'.freeze

  def perform(cover_image_id)

    @cover_image = CoverImage.find(cover_image_id)

    available_ids = @cover_image.present_ids.except('upc', 'ht_id')
    unless available_ids.any?
      @cover_image.status = 'not_found'
      @cover_image.response_data = "No valid identifiers to search by."
      @cover_image.service_name = 'openlibrary.org'
      @cover_image.save
      # end of the line
      return
    end

    available_ids.each do |id_name, id_values|
      catch :image_found do

        id_values.split(/,\s?/).each do |id_value|
          image_url = "#{BASE_URL}/b/#{id_name}/#{id_value}.jpg?default=false"

          begin
            @cover_image.image = URI.parse(image_url)
            @cover_image.response_data = image_url
            @cover_image.service_name = 'openlibrary.org'
            throw :image_found

          rescue OpenURI::HTTPError => e
            # catch missing images and continue to loop over available ids
            logger.info "Missing OpenLibrary Image for this id: #{id_name}:#{id_value}"
          end
          @cover_image.image = nil
          sleep(1)
        end
      end
    end
    if @cover_image.image.blank?
      # no image after searching all providers
      @cover_image.service_name = 'none'
      @cover_image.response_data = "Not found after searching all providers"
    end
    save_if_found

  rescue StandardError => e
    @cover_image.update status: 'error' if @cover_image
    # end of the line
    raise e
  end

end
