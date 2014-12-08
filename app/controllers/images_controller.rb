class ImagesController < ApplicationController
  def create
    image = Image.create params[:image]
  end
end
