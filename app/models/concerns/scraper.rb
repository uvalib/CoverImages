# Scraper concern
module Scraper
  extend ActiveSupport::Concern

  # This prevents failed lookups from retrying too much
  LOOKUP_LIMIT = 1.day.freeze

  # This is the primary way of looking up cover images
  # It will kick off other jobs which will rate-limit themselves
  # If an image is not found from one source,
  # the job will start the next service in line
  def lookup
    logger.info "searching #{self.doc_id}"

    raise "not saved yet" unless self.id

    # Check if the last image search was more than a day ago
    if self.last_search.nil? ||
       self.last_search < (DateTime.current - LOOKUP_LIMIT) ||
       !self.locked

      self.last_search = DateTime.current

      if self.music?
        MusicBrainzWorker.perform_async self.id
        # fails over to Music Brainz
      else
        # google is the first source to try
        GoogleWorker.perform_async self.id

        # if google fails, it kicks off the Syndetics job
        # if syndetics fails, it kicks off the OpenLibrary job
      end
    end

    # Used to stop the after_commit callback
    self.run_lookup = false
    save

  rescue StandardError => e
    self.status = 'error'
    self.response_data = e
  end

end
