class Admin::CoverImagesController < ApplicationController

  before_filter :get_cover_image, only: [:show, :edit, :update, :destroy]

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
      flash[:success] = "Successfully created: #{@cover_image.name}"
      redirect_to action: :index

    else
      render :new
    end
  end

  def edit
  end

  def update
    if @cover_image.update(cover_image_params)
      flash[:success] = "Successfully updated: #{@cover_image.name}"
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    if @cover_image.destroy
      flash[:success] = "Successfully deleted: #{@cover_image.name}"
      redirect_to action: :index
    else
      flash[:alert] = "Could not delete: #{@cover_image.name}"
      redirect_to action: :index
    end
  end

  private

  def cover_image_params
    params.require(:cover_image).permit(:name, :image)
  end

  def get_cover_image
    @cover_image = CoverImage.find(params[:id])
  end

end
