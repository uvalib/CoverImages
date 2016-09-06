class CoverImagesController < ApplicationController


  def show
    cover_image = CoverImage.find_or_initialize_by(doc_id: cover_image_params[:id])

    if cover_image && cover_image.image.present?
      uri = generate_image_uri( cover_image.image.path )
      render json: {image_base64: uri}

    else
      uri = generate_image_uri( Rails.root.join('public','images', 'default_bookcover.gif') )
      render json: {image_base64: uri}
    end

  end

  private

  def cover_image_params
    #TODO: define request format
    params.permit(:doc_type, :doc_id, :isbn, :oclc, :lccn, :upc, :mbid, :artist, :album)
  end

  def generate_image_uri path
    image = Base64.encode64(File.open(path).read)
    "data:image/png;base64,#{image}"
  end

end
