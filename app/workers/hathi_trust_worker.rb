# Hathi Trust Worker
class HathiTrustWorker < ApplicationWorker

  sidekiq_options throttle: { threshold: 2, period: 1.second }, retry: false

  # Set up and use OAuth for HT
  def ht_oauth
    @consumer ||= OAuth::Consumer.new(
      ENV['HATHI_TRUST_ACCESS_KEY'],
      ENV['HATHI_TRUST_SECRET_KEY'],
      {
        site: 'https://babel.hathitrust.org/cgi/htd',
        http_method: :post,  scheme: :query_string
      }
    )

  end

  def perform(cover_image_id)
    @cover_image = CoverImage.find cover_image_id

    response = ht_oauth.request(
      :get, "/volume/pageimage/#{@cover_image.ht_id}/1?v=2&res=2&format=jpeg"
    )

    if (response.code == '200') && response.body
      temp_file = Tempfile.new(['temp','.jpeg'], encoding: 'ascii-8bit')
      begin
        temp_file.write(response.body)
        @cover_image.image = temp_file
      ensure
        temp_file.close
        temp_file.unlink
      end
    else
      # not found
    end

    @cover_image.response_data = "Retrieved from the Hathi Trust API"
    @cover_image.service_name = 'Hathi Trust'

    save_if_found do
      SyndeticsWorker.perform_async(cover_image_id)
    end

  rescue StandardError => e
    @cover_image.update status: 'error'
    SyndeticsWorker.perform_async(cover_image_id)
    raise e
  end


end
