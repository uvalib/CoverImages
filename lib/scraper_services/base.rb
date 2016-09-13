class ScraperServices::Base

  # @return [CoverImage]
  def self.process cover_image
    raise "define this in a child service"
  end


end
