# Application Worker: All workers inherit from this class
class ApplicationWorker
  include Sidekiq::Worker

  SLEEP_TIME = 0

  # saves a cover image if a new one is set.
  # Yields the next scraper to try if no image is found
  def save_if_found
    @cover_image.status =
      if @cover_image.image.present?
        'processed'
      else
        'not_found'
      end
    ActiveRecord::Base.connection_pool.with_connection do
      @cover_image.save
    end

    return unless (@cover_image.status == 'not_found') && block_given?

    sleep(SLEEP_TIME)
    yield
  end

  # Provides sane regex for artist matching
  # @param [String] Artist Name
  # @return [Regexp] Regular Expression
  def artist_regex(artist_name)
    regex = '^'
    # match all words, anywhere in the string, case insensitive, ignoring non-word chars
    artist_name.split(/\W+/).each do |word|
      regex += "(?=.*#{word}.*)"
    end
    regex += '.*$'
    /#{regex}/i
  end
end
