class CoverImagesController < ApplicationController

  ##
  #
  def show
    cover_image = CoverImage.find_or_initialize_by(
      doc_id: params[:id]
      )

    uri = nil
    not_found = true
    path = ''

    if cover_image && cover_image.image.present?
      path = cover_image.image.path
      not_found = false
    else
      cover_image.assign_attributes cover_image_params.merge(run_lookup: true)
      cover_image.save
      path = Rails.root.join('public','images', 'default_bookcover.gif')
      not_found = true
    end

    respond_to do |format|
      format.html {send_file path, disposition: 'inline'}
      format.json do
        uri = generate_image_uri( path )
        render json: {image_base64: uri,
          errors: cover_image.errors.as_json,
          not_found: not_found, status: :success}
      end
    end

  end

  private

  def cover_image_params
    params.permit( # :id is the solr id in this case
                  :doc_type,
                  :isbn, :oclc, :lccn, :upc, :mbid, :artist_name, :album_name, :title)
  end

  def generate_image_uri path
    image = Base64.encode64(File.open(path).read)
    "data:image/png;base64,#{image}"
  end

end
