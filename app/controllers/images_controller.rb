class ImagesController < ActionController::Base
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

  private

  def image_params
    params.require(:image).permit(:url)
  end
end
