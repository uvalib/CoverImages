class ScraperServices::Base

  # @return [Boolean] found or not
  def self.process cover_image
    raise "define this in a child service"
  end

end
