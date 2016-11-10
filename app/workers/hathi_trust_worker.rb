# Hathi Trust Worker
class HathiTrustWorker < ApplicationWorker

  sidekiq_options throttle: { threshold: 50, period: 30.seconds }, retry: false

  # Set up and use OAuth for HT
  def ht_oauth
    @consumer ||= OAuth::Consumer.new(
      ENV['HATHI_TRUST_ACCESS_KEY'],
      ENV['HATHI_TRUST_SECRET_KEY'],
      site: 'https://babel.hathitrust.org/cgi/htd',
      http_method: :post, scheme: :query_string
    )

  end

  def perform(cover_image_id)
    @cover_image = CoverImage.find cover_image_id

    page_num = select_title_or_cover_page



    response = ht_oauth.request(
      :get, "/volume/pageimage/#{@cover_image.ht_id}/#{page_num}?v=2&res=2&format=jpeg"
    )

    if (response.code == '200') && response.body
      temp_file = Tempfile.new(['hathi', '.jpeg'], encoding: 'ascii-8bit')
      begin
        temp_file.write(response.body)
        @cover_image.image = temp_file
      ensure
        temp_file.close
        temp_file.unlink
      end
    end

    @cover_image.response_data = "Retrieved from the Hathi Trust API"
    @cover_image.service_name = 'Hathi Trust'

    save_if_found do
      GoogleWorker.perform_async(cover_image_id)
    end

  rescue StandardError => e
    @cover_image.update status: 'error'
    GoogleWorker.perform_async(cover_image_id)
    raise e
  end

  private

  def select_title_or_cover_page
    begin
    meta_response = ht_oauth.request(
      :get, "/volume/meta/#{@cover_image.ht_id}?v=2&format=json"
    )
    meta = JSON.parse(meta_response.body)
    title_pages = meta["htd:seqmap"].first['htd:seq'].select do |h|
      h["htd:pfeat"].include? "TITLE"
    end

    if title_pages.none?
      1
    else
      title_pages.first['pseq'] || 1
    end

    rescue
      return 1
    end
  end

end
