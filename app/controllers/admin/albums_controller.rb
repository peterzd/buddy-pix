class Admin::AlbumsController < Admin::ApplicationController
  respond_to :html

  def index
    @cards = Album.all
  end

  def destroy
    @card = Album.find params[:id]
    @card.destroy
    redirect_to admin_albums_path
  end

  def new
    @album = Album.new
    respond_with @album
  end

  def create
    @album = Album.new album_params.except(:cover_image).merge(creator: current_user)
    @album.save

    if album_params[:cover_image]
      image = Image.create picture: album_params[:cover_image]
      @album.set_cover_image image
    end

    redirect_to admin_albums_path
  end

  private
  def album_params
    params.require(:album).permit(:id, :name, :last_name, :caption, :cover_image)
  end
end
