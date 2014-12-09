class ImagesController < ApplicationController
  def create
    image = Image.create params[:image]
  end

  def photo_upload
    @image = Image.create picture: params[:image][:picture]
  end

end
