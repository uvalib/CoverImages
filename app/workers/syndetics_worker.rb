# Syndetics Worker
class SyndeticsWorker < ApplicationWorker
  sidekiq_options throttle: { threshold: 2, period: 1.second }, retry: false

  BASE_URL = 'https://syndetics.com/index.aspx'.freeze

  def perform(cover_image_id)

    @cover_image = CoverImage.find(cover_image_id)
    params = {}
    # allow duplicate keys
    params.compare_by_identity
    @cover_image.isbn.split.each do |isbn|
      params['isbn'.dup] = isbn
    end if @cover_image.isbn
    @cover_image.oclc.split.each do |oclc|
      params['oclc'.dup] = oclc
    end if @cover_image.oclc
    unless params.any?
      @cover_image.status = 'not_found'
      @cover_image.service_name = 'Syndetics'
      @cover_image.response_data = "No valid identifiers to search by."
      @cover_image.save
      OpenLibraryWorker.perform_async(cover_image_id)
      return
    end

    request_uri = URI.parse "#{BASE_URL}?#{params.to_param}/mc.jpg"

    @cover_image.image = request_uri
    dimensions = Paperclip::Geometry.from_file(
      @cover_image.image.queued_for_write[:original].path
    )
    if dimensions.to_s == '1x1'
      @cover_image.status = 'not_found'
      @cover_image.image = nil
      @cover_image.response_data = "Request URI: #{request_uri}"
    else
      @cover_image.status = 'processed'
      @cover_image.response_data =
        "Only the image itself was returned. RequestURI:(#{request_uri})"
    end
    @cover_image.service_name = 'Syndetics'

    save_if_found do
      OpenLibraryWorker.perform_async(cover_image_id)
    end

  rescue StandardError => e
    @cover_image.update status: 'error', response_data: e

    OpenLibraryWorker.perform_async(cover_image_id)
    raise e
  end

end
