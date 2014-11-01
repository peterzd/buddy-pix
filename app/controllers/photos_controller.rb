class PhotosController < ApplicationController
  before_action :set_photo, except: [:new, :create]

  def like
    authorize :photo, :like?
    current_user.like_photo @photo, mood: params[:mood]
  end

  def new
    @photo = set_card.photos.new
    authorize @photo
  end

  private
  def set_photo
    @photo = Photo.find params[:id]
  end

  def set_card
    @card = Album.find params[:card_id]
  end
end
