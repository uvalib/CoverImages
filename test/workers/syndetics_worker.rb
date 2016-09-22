require 'test_helper'
class SyndeticsWorkerTest < ActiveSupport::TestCase

  def test_good_cover_image

    VCR.use_cassette('known_book_syndetics') do
      Sidekiq::Testing.inline!
      @cover_image = create(:known_book)
      SyndeticsWorker.perform_async(@cover_image.id)
      @cover_image.reload
      assert @cover_image.image.present?
    end
  end
end

