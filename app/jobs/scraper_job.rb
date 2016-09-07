class ScraperJob < ApplicationJob
  queue_as :scrapers

  def perform(cover_image_id)
  end
end
