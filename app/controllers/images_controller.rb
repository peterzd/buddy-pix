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

  def download
    image = Image.find params[:id]
    photo = image.imageable
    if photo.instance_of? Photo
      card = photo.album
      authorize card, :show?
      file_name = image.picture_file_name
      file_type = image.picture_content_type

      send_file(
        "#{Rails.root}/public/#{image.picture.url(:original).split(/\?/).first}",
        filename: file_name,
        type: file_type
      )
    else
      redirect_to root_path
    end
  end

end
