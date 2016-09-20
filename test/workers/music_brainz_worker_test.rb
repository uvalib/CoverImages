require 'test_helper'
class MusicBrainzWorkerTest < ActiveSupport::TestCase

  def test_good_album_cover
    Sidekiq::Testing.inline!
    @cover_image = create(:known_album)
    MusicBrainzWorker.perform_async(@cover_image.id)
    @cover_image.reload
    assert @cover_image.image.present?

  end

end
