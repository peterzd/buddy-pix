class PhotosController < ApplicationController
  before_action :set_photo

  def like
    authorize :photo, :like?
    current_user.like_photo @photo, mood: params[:mood]
  end

  private
  def set_photo
    @photo = Photo.find params[:id]
  end
end
