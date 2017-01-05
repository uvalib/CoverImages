# controller for /admin/cover_images
class Admin::CoverImagesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_raven_user

  before_action :get_cover_image,
    only: [:show, :edit, :update, :reprocess, :destroy]

  def index
    @cover_images = CoverImage.all
      .search(params.dig(:cover_image, :search_term))
      .page(params[:page]).per(20)
  end

  def new
    @cover_image = CoverImage.new
  end

  def create
    @cover_image = CoverImage.new(cover_image_params)
    if @cover_image.image.dirty?
      # Lock the image if it was manually added
      @cover_image.locked = true
      @cover_image.status = CoverImage::STATUSES.keys.last
    end
    if @cover_image.save
      flash[:success] = "Successfully created: #{@cover_image.doc_id}"
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
  end

  def update
    @cover_image.assign_attributes cover_image_params
    if @cover_image.image.dirty?
      # Lock the image if it was manually added
      @cover_image.locked = true
      @cover_image.status = CoverImage::STATUSES.keys.last
    end
    if @cover_image.save
      @cover_image.lookup
      flash[:success] = "Successfully updated: #{@cover_image.doc_id}"
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def reprocess
    @cover_image.lookup true

    redirect_to action: params[:redirect]

  end

  def destroy
    if @cover_image.destroy
      flash[:success] = "Successfully deleted: #{@cover_image.doc_id}"
    else
      flash[:alert] = "Could not delete: #{@cover_image.doc_id}"
    end
    redirect_to action: :index
  end

  private

  def cover_image_params
    params.require(:cover_image).permit(
      :doc_type, :doc_id, :status,
      :isbn, :oclc, :lccn, :upc, :ht_id,
      :mbid, :artist_name, :album_name,
      :image
    )
  end

  def search_params
    params.permit(:search_term)
  end

  def get_cover_image
    @cover_image = CoverImage.find(params[:id])
  end

end
