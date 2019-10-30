class ImagesController < ApplicationController
  def index
    @images = if params[:tag].present?
      Image.tagged_with(params[:tag]).order(created_at: :desc)
    else
      Image.order created_at: :desc
    end
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)

    if @image.save
      redirect_to image_path(@image.id), notice: 'Image successfully saved!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @image = Image.find(params[:id])
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    redirect_to images_path, notice: 'You have successfully deleted the image.'
  end

  private

  def image_params
    params.require(:image).permit(:url, :tag_list)
  end
end
