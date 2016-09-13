module Scraper
  extend ActiveSupport::Concern
  include ScraperServices

  # This is the primary way of looking up cover images
  # It will kick off other jobs which will rate-limit themselves
  # If an image is not found from one source,
  # the job will start the next service in line
  def lookup
    logger.info "scraping #{self.doc_id}"

    begin

      if self.music?
        ScraperServices::LastFM.process self
      else
        # google is the first source to try
        GoogleScraper.perform_later self.id

        # if google fails, it kicks off the Syndetics job
        # if syndetics fails, it kicks off the OpenLibrary job
       #unless self.image.dirty?
       #  ScraperServices::Syndetics.process self
       #end
       #unless self.image.dirty?
       #  ScraperServices::OpenLibrary.process self
       #end

      end
    rescue StandardError => e
      self.status = 'error'
      raise e
    end

    save
  end

end
