module Scraper
  extend ActiveSupport::Concern

  # This is the primary way of looking up cover images
  # It will kick off other jobs which will rate-limit themselves
  # If an image is not found from one source,
  # the job will start the next service in line
  def lookup
    logger.info "scraping #{self.doc_id} -run_lookup: #{run_lookup}"

    begin

      raise "no id" unless self.id

      if self.music?
        LastFMWorker.perform_async self.id
      else
        # google is the first source to try
        GoogleWorker.perform_async self.id

        # if google fails, it kicks off the Syndetics job
        # if syndetics fails, it kicks off the OpenLibrary job

      end
    rescue StandardError => e
      self.status = 'error'
      self.response_data = e
    end

    self.run_lookup = false
    save
  end

end
