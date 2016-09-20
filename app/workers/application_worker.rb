class ApplicationWorker
  include Sidekiq::Worker

  SLEEP_TIME = 0.freeze

  # saves a cover image if a new one is set.
  # Yields the next scraper to try if no image is found
  def save_if_found
    if @cover_image.image.present?
      @cover_image.status = 'processed'
    else
      @cover_image.status = 'not_found'
    end
    ActiveRecord::Base.connection_pool.with_connection do
      @cover_image.save
    end
    if @cover_image.status == 'not_found' && block_given?
      sleep(SLEEP_TIME)
      yield
    end
  end
end
