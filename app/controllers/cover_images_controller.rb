# Controller for /cover_images
class CoverImagesController < ApplicationController

  ##
  #
  def show
    # params[:id] is the solr id in this case
    cover_image = CoverImage.find_or_initialize_by(
      doc_id: params[:id]
    )

    not_found = true
    image_url = URI.join(request.url, cover_image.image.url)

    if cover_image && cover_image.image.present?
      path = cover_image.image.path
      not_found = false
    else
      cover_image.assign_attributes cover_image_params.merge(run_lookup: true)
      cover_image.save
      not_found = true
      path = cover_image.default_image_path
    end

    respond_to do |format|
      format.html {send_file image_url, disposition: 'inline', url_based_filename: true}
      format.json do
        uri = generate_image_uri(path)
        render json: {
          image_url: image_url,
          image_base64: uri,
          errors:    cover_image.errors.as_json,
          not_found: not_found
        }
      end
    end

  end

  private

  def cover_image_params
    params.permit(
      :doc_type, :title,
      :isbn, :oclc, :lccn, :upc, :mbid, :ht_id, :issn,
      :artist_name, :album_name
    )
  end

  def generate_image_uri(path)
    image = Base64.encode64(File.open(path, &:read))
    "data:image/png;base64,#{image}"
  end

end
