require 'test_helper'
class GoogleWorkerTest < ActiveSupport::TestCase

  def test_good_cover_image

    VCR.use_cassette('known_book_google') do
      Sidekiq::Testing.inline!
      @cover_image = create(:known_book)
      GoogleWorker.perform_async(@cover_image.id)
      @cover_image.reload
      assert @cover_image.image.present?
    end
  end
end
