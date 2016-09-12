class Admin::CoverImagesController < ApplicationController

  before_action :get_cover_image, only: [:show, :edit, :update, :reprocess, :destroy]

  def index
    @cover_images = CoverImage.all.page(params[:page]).per(20)
  end

  def show
  end

  def new
    @cover_image = CoverImage.new
  end

  def create
    @cover_image = CoverImage.new(cover_image_params)
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
    if @cover_image.update(cover_image_params)
      @cover_image.scrape_job
      flash[:success] = "Successfully updated: #{@cover_image.doc_id}"
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def reprocess
    @cover_image.scrape_job

    redirect_to action: params[:redirect]

  end

  def destroy
    if @cover_image.destroy
      flash[:success] = "Successfully deleted: #{@cover_image.doc_id}"
      redirect_to action: :index
    else
      flash[:alert] = "Could not delete: #{@cover_image.doc_id}"
      redirect_to action: :index
    end
  end

  private

  def cover_image_params
    #TODO: define request format
    params.require(:cover_image).permit(:doc_type, :doc_id, :status,
                                        :isbn, :oclc, :lccn, :upc,
                                        :mbid, :artist_name, :album_name,
                                        :image)
  end

  def get_cover_image
    @cover_image = CoverImage.find(params[:id])
  end

end
