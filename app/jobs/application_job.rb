class ApplicationJob < ActiveJob::Base


  # saves a cover image if a new one is set.
  # Yields the next scraper to try if no image is found
  def save_if_found cover_image
    if cover_image.image.dirty?
      cover_image.status = 'processed'
    else
      cover_image.status = 'not_found'
    end
    cover_image.save
    ActiveRecord::Base.after_transaction do
      if cover_image.status == 'not_found'
        yield
      end
    end
  end
end
