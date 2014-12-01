class PhotosController < ApplicationController
  before_action :set_card
  before_action :set_photo, except: [:new, :create]

  def show
    authorize @card, :show?
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
    photo = @card.photos.build photo_params.except(:image, :tagged_users).merge(creator: current_user)
    authorize photo

    if PhotosService.new(photo).save_photo(photo_params)
      redirect_to card_path @card
    else
      render nothing: true
    end
  end

  def download
    authorize @card, :show?
    file_name = @photo.image.picture_file_name
    file_type = @photo.image.picture_content_type

    send_file(
      "#{Rails.root}/public/#{@photo.picture_url(:original).split(/\?/).first}",
      filename: file_name,
      type: file_type
    )
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
    params.require(:photo).permit(:id, :title, :description, { image: [:picture] }, :tagged_users)
  end
end

