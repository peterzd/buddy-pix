class Admin::PhotosController < Admin::ApplicationController
  respond_to :html

  def index
    @photos = Photo.all
  end

  def destroy
    @photo = Photo.find params[:id]
    @photo.destroy
    redirect_to admin_photos_path
  end
end
