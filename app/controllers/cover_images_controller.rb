class CoverImagesController < ApplicationController


  def show
    cover_image = CoverImage.find_or_initialize_by(doc_id: cover_image_params[:id])

    if cover_image && cover_image.image.present?
      send_file cover_image.image.path,
        type: cover_image.image_content_type,
        disposition: :inline

    else
      image = Base64.encode64(File.open(Rails.root.join('public','images', 'default_bookcover.gif')).read)
      uri  = "data:image/png;base64,#{image}"
      render json: {image_base64: uri}
    end

  end

  private

  def cover_image_params
    #TODO: define request format
    params.permit(:doc_type, :doc_id, :isbn, :oclc, :lccn, :upc, :mbid, :artist, :album)
  end

end
