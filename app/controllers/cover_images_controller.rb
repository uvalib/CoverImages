class CoverImagesController < ApplicationController

  ##
  #
  def show
    cover_image = CoverImage.find_or_initialize_by(
      doc_id: cover_image_params[:id],
      doc_type: cover_image_params[:doc_type])

    if cover_image && cover_image.image.present?
      uri = generate_image_uri( cover_image.image.path )
      render json: {image_base64: uri, not_found: false}
    else

      if cover_image.save
        Scraper.perform_later(cover_image.id)
      end

      uri = generate_image_uri(
        Rails.root.join('public','images', 'default_bookcover.gif')
      )
      render json: {image_base64: uri,
        errors: cover_image.errors.as_json,
        not_found: true}
    end

  end

  private

  def cover_image_params
    params.permit(:doc_type, :doc_id, #required
                  :isbn, :oclc, :lccn, :upc, :mbid, :artist_name, :album_name)
  end

  def generate_image_uri path
    image = Base64.encode64(File.open(path).read)
    "data:image/png;base64,#{image}"
  end

end
