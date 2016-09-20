require 'test_helper'
class GoogleWorkerTest < ActiveSupport::TestCase

  def setup
  end

  def test_good_cover_image
    Sidekiq::Testing.inline!
    @cover_image = create(:known_book)
    GoogleWorker.perform_async(@cover_image.id)
    @cover_image.reload
    assert @cover_image.image.present?
  end



end
