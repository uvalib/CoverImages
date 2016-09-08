class CoverImagesController < ApplicationController

  ##
  #
  def show
    cover_image = CoverImage.find_or_initialize_by(
      doc_id: cover_image_params[:id]
      )

    uri = nil
    not_found = true
    path = ''

    if cover_image && cover_image.image.present?
      path = cover_image.image.path
      not_found = false
    else
      cover_image.doc_type = cover_image_params[:doc_type]
      cover_image.save
      path = Rails.root.join('public','images', 'default_bookcover.gif')
      not_found = false
    end

    respond_to do |format|
      format.html {send_file path, disposition: 'inline'}
      format.json do
        uri = generate_image_uri( path )
        render json: {image_base64: uri,
          errors: cover_image.errors.as_json,
          not_found: true}
      end
    end

  end

  private

  def cover_image_params
    params.permit(:id, #solr id required
                  :doc_type,
                  :isbn, :oclc, :lccn, :upc, :mbid, :artist_name, :album_name, :title)
  end

  def generate_image_uri path
    image = Base64.encode64(File.open(path).read)
    "data:image/png;base64,#{image}"
  end

end
