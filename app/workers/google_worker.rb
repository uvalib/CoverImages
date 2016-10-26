# Google Worker
class GoogleWorker < ApplicationWorker

  sidekiq_options throttle: { threshold: 2, period: 1.second }, retry: false

  BASE_URL = 'https://books.google.com/books'.freeze

  # required by google, doesnt matter, needs to be consistent
  CALLBACK_LENGTH = 2

  def perform(cover_image_id)
    @cover_image = CoverImage.find(cover_image_id)

    bibkeys = ''
    CoverImage::IDENTIFIERS.without('upc').each do |id_type|
      next unless (id = @cover_image.send(id_type))
      bibkeys += ',' unless bibkeys.empty?
      bibkeys += "#{id_type.upcase}:#{id.gsub("\s+", '')}"
    end
    params = {
      bibkeys:  bibkeys,
      jscmd:    'viewapi',
      callback: 'a' * CALLBACK_LENGTH
    }
    response = HTTParty.get(
      BASE_URL,
      query: params
    )
    # Strip off method name and closing ');' in response
    response = JSON.parse(response.parsed_response[(CALLBACK_LENGTH + 1)..-3])
    response.each do |_key, val|
      next unless val['thumbnail_url'].present?
      # dont curl the corner of the book
      image_url = val['thumbnail_url'].gsub('&edge=curl', '')
      @cover_image.image = URI.parse(image_url)
      break
    end
    @cover_image.response_data = response
    @cover_image.service_name = 'google'

    save_if_found do
      SyndeticsWorker.perform_async(cover_image_id)
    end

  rescue StandardError => e
    @cover_image.update status: 'error'
    SyndeticsWorker.perform_async(cover_image_id)
    raise e

  end

end
