class ImagesController < ApplicationController
  def new
    @image = Image.new
  end

  def create
    @image = Image.new image_params
    @image.save!
    render nothing: true
  end

  private
  def image_params
    params.require(:image).permit(:id, :picture)
  end
end
