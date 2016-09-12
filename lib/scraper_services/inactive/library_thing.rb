class ScraperServices::LibraryThing < ScraperServices::Base

  # LibraryThing's API seems to be broken. no images are returned, only 1x1 transparent gifs

  BASE_URL = "http://covers.librarything.com/devkey/#{ENV['LIBRARY_THING_API_KEY']}/large/isbn/"

  def self.process cover_image

    if cover_image.isbn.present?
      response = HTTParty.get( "#{BASE_URL}#{cover_image.isbn}/" )
      if response.code == 404
        cover_image.status = 'not_found'
      else


      end


    else
      cover_image.status = 'not_found'
    end

  end

end
