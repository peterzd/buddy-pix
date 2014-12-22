class Admin::PhotosController < Admin::ApplicationController
  respond_to :html
  before_action :set_photo, except: [:index]

  def index
    @photos = Photo.all
  end

  def destroy
    @photo.destroy
    redirect_to admin_photos_path
  end

  def show
  end

  private
  def set_photo
    @photo = Photo.find params[:id]
  end
end

