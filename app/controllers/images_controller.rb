class ImagesController < ApplicationController
  respond_to :html, :json

  def create
    image = Image.create params[:image]
  end

  def photo_upload
    @image = Image.create picture: params[:image][:picture]
    respond_to do |format|
      format.json { render json: @image.to_json, content_type: "text/html" }
    end
  end

  def destroy
    image = Image.find params[:id]
    @image_id = image.id
    image.destroy
  end

end
