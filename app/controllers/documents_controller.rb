class DocumentsController < ApplicationController


  def show
    doc = Document.find_by(params[:id])

    if doc && doc.image.present?
      send_file doc.image.path, type: doc.image_file_type, disposition: :inline
    else
      # look it up
      render plain: "nothing"
    end

  end

end
