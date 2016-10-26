require 'test_helper'
class MusicBrainzWorkerTest < ActiveSupport::TestCase

  def test_good_album_cover

    VCR.use_cassette('known_album_music_brainz') do
      Sidekiq::Testing.inline!
      @cover_image = create(:known_album)
      MusicBrainzWorker.perform_async(@cover_image.id)
      @cover_image.reload
      assert @cover_image.image.present?
    end
  end
end
