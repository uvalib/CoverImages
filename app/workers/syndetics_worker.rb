class SyndeticsWorker < ApplicationWorker
  sidekiq_options throttle: { threshold: 2, period: 1.second }, retry: false

  BASE_URL = 'https://syndetics.com/index.aspx'

  def perform cover_image_id
    begin
    @cover_image = CoverImage.find(cover_image_id)

    unless @cover_image.isbn
      @cover_image.service_name = 'Syndetics'
      @cover_image.status = 'not_found'
      @cover_image.save
      sleep(SLEEP_TIME)
      OpenLibraryWorker.perform_async(cover_image_id)
      return @cover_image
    end

    request_uri = URI.parse("#{BASE_URL}?isbn=#{@cover_image.isbn}/mc.jpg")

    @cover_image.image = request_uri
    @cover_image.image_file_name = "#{@cover_image.doc_id}.jpeg"
    @cover_image.image_content_type = 'image/jpeg'
    dimensions = Paperclip::Geometry.from_file(@cover_image.image.queued_for_write[:original].path)
    if dimensions.to_s == '1x1'
      @cover_image.status = 'not_found'
      @cover_image.image = nil
      @cover_image.response_data = "Request URI: #{request_uri} "
    else
      @cover_image.status = 'processed'
      @cover_image.response_data = "Only the image itself was returned. RequestURI:(#{request_uri})"
    end
    @cover_image.service_name = 'Syndetics'

    save_if_found do
      OpenLibraryWorker.perform_async(cover_image_id)
    end

    rescue StandardError => e
      @cover_image.update status: 'error', response_data: e
      sleep(SLEEP_TIME)

      OpenLibraryWorker.perform_async(cover_image_id)
      raise e
    end

  end

end
