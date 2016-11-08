require 'test_helper'
class HathiTrustWorkerTest < ActiveSupport::TestCase

  def test_good_cover_image

    VCR.use_cassette(
      'known_good_hathi_trust',
      match_requests_on: [
        :method, :path,
        VCR.request_matchers.uri_without_params(
          :oauth_timestamp, :oauth_nonce, :oauth_signature
        )
      ]
    ) do
      Sidekiq::Testing.inline!
      @cover_image = create(:known_hathi_trust)
      HathiTrustWorker.perform_async(@cover_image.id)
      @cover_image.reload
      assert @cover_image.image.present?
    end
  end
end
