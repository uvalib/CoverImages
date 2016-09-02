class CoverImagesController < ApplicationController

  respond_to :json

  def show
    doc = CoverImages.find_by(params[:id])

    if doc && doc.image.present?
      send_file doc.image.path, type: doc.image_file_type, disposition: :inline
    else
      # look it up
      render plain: "TODO: lookup"
    end

  end

end
