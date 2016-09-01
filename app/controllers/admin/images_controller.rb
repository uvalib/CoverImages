class Admin::ImagesController < ApplicationController

  before_filter :get_document, only: [:show, :edit, :update, :destroy]

  def index
    @documents = Document.all.page(params[:page]).per(20)
  end

  def show
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      flash[:success] = "Successfully created: #{@document.name}"
      redirect_to action: :index

    else
      render :new
    end
  end

  def edit
  end

  def update
    if @document.update(document_params)
      flash[:success] = "Successfully updated: #{@document.name}"
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    if @document.destroy
      flash[:success] = "Successfully deleted: #{@document.name}"
      redirect_to action: :index
    else
      flash[:alert] = "Could not delete: #{@document.name}"
      redirect_to action: :index
    end
  end

  private

  def document_params
    params.require(:document).permit(:name, :image)
  end

  def get_document
    @document = Document.find(params[:id])
  end

end
