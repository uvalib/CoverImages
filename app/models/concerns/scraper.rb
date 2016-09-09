module Scraper
  extend ActiveSupport::Concern
  include ScraperServices

  def lookup
    logger.info "scraping #{self.doc_id}"


    if self.music?
      ScraperServices::LastFM.process self
    else
      ScraperServices::Google.process self

    end
  end

end
