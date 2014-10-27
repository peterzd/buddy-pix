class AlbumsController < ApplicationController
  respond_to :html, :json
  before_action :set_album, only: [:show, :edit, :update, :destroy]

  def index
    @albums = Album.all
    respond_with(@albums)
  end

  def show
    respond_with(@album)
  end

  def new
    @album = Album.new
    authorize @album
    respond_with(@album)
  end

  def edit
  end

  def create
    @album = Album.new(album_params.except(:cover_image))
    @album.save

    if album_params[:cover_image]
      image = Image.create album_params[:cover_image]
      @album.set_cover_image image
    end

    render nothing: true
  end

  def update
    @album.update(album_params)
    respond_with(@album)
  end

  def destroy
    @album.destroy
    respond_with(@album)
  end

  private
    def set_album
      @album = Album.find(params[:id])
    end

    def album_params
      params.require(:album).permit(:name, :private, :caption, { cover_image: [:picture] })
    end
end
