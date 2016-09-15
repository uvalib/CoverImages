class ApplicationWorker
  include Sidekiq::Worker


  # saves a cover image if a new one is set.
  # Yields the next scraper to try if no image is found
  def save_if_found
    if @cover_image.image.dirty?
      @cover_image.status = 'processed'
    else
      @cover_image.status = 'not_found'
    end
    @cover_image.save
    if @cover_image.status == 'not_found' && block_given?
      sleep(4)
      yield
    end
  end
end
