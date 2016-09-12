module Scraper
  extend ActiveSupport::Concern
  include ScraperServices

  def lookup
    logger.info "scraping #{self.doc_id}"

    begin

      if self.music?
        ScraperServices::LastFM.process self
      else
        ScraperServices::Google.process self
        unless self.image.dirty?

          ScraperServices::Syndetics.process self
        end

      end
    rescue StandardError => e
      self.status = 'error'
      raise e
    end

    save
  end

end
