class PhotosController < ApplicationController
  before_action :set_card
  before_action :set_photo, except: [:new, :create]

  def show
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
    set_card
    @photo = @card.photos.build photo_params.except(:image).merge(creator: current_user)
    authorize @photo

    if @photo.save
      if photo_params[:image]
        image = Image.create photo_params[:image]
        @photo.image = image
      end
      redirect_to cards_path
    else
      logger.info "there's error when trying to save the photo"
      render nothing: true
    end
  end

  def download
    file_name = @photo.image.picture_file_name
    file_type = @photo.image.picture_content_type

    send_file(
      "#{Rails.root}/public/#{@photo.picture_url(:original).split(/\?/).first}",
      filename: file_name,
      type: file_type
    )
  end

  private
  def set_photo
    @photo = Photo.find params[:id]
  end

  def set_card
    @card = Album.find params[:card_id]
  end

  def photo_params
    params.require(:photo).permit(:id, :title, :description, { image: [:picture] })
  end
end
