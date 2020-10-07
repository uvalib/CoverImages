# Controller for /cover_images
class CoverImagesController < ApplicationController

  ##
  #
  def show
    # params[:id] is the solr id in this case
    cover_image = CoverImage.find_or_initialize_by(
      doc_id: params[:id]
    )


    image_url = URI.join(request.url, cover_image.image.url)

    if cover_image && cover_image.image.present?
      path = cover_image.image.path
    else
      cover_image.assign_attributes cover_image_params.merge(run_lookup: true)
      cover_image.save
      path = cover_image.default_image_path
    end

    status_code = case cover_image.status
    when 'unprocessed'
      # 202
      :accepted
    when 'not_found' || 'error'
      :not_found
    else # processed and found
      :ok
    end

    respond_to do |format|
      format.html do
        send_file path, disposition: 'inline', url_based_filename: true, status: status_code
      end
      format.json do
        uri = generate_image_uri(path)
        render json: {
          image_url: image_url,
          image_base64: uri,
          errors:    cover_image.errors.as_json,
          status: cover_image.status
        },
          status: status_code
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
