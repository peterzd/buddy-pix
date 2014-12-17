class PhotosController < ApplicationController
  before_action :set_card
  before_action :set_photo, except: [:new, :create]

  def show
    card = @photo.album
    authorize card, :show?
  end

  def like
    authorize :photo, :like?
    current_user.like_photo @photo, mood: params[:mood]
  end

  def new
    @photo = set_card.photos.new
    authorize @photo
  end

  def create
    photo = @card.photos.build photo_params.except(:image_ids, :tagged_users).merge(creator: current_user)
    authorize photo

    if PhotosService.new(photo).save_photo(photo_params)
      redirect_to card_path @card
    else
      render nothing: true
    end
  end

  def destroy
    @photo.destroy
    redirect_to card_path @card
  end

  private
  def set_photo
    @photo = Photo.find params[:id]
  end

  def set_card
    @card = Album.find params[:card_id]
  end

  def photo_params
    params.require(:photo).permit(:id, :title, :description, :image_ids, :tagged_users)
  end
end

