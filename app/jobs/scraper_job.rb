class ScraperJob < ApplicationJob
  queue_as :scrapers

  def perform(cover_image_id)
    ci = CoverImage.find(cover_image_id)
    ci.lookup

  end
end
