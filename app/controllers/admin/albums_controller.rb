class Admin::AlbumsController < Admin::ApplicationController
  respond_to :html
  before_action :set_album, only: [:destroy, :hide_card, :view_card]

  def index
    @cards = Album.all
  end

  def destroy
    @album.destroy
    redirect_to admin_albums_path
  end

  def new
    @album = Album.new
    respond_with @album
  end

  def hide_card
    @album.update hidden: true
    redirect_to admin_albums_path
  end

  def view_card
    @album.update hidden: false
    redirect_to admin_albums_path
  end

  # Peter at 11.5: this action method is duplicated with the one in AlbumsController#create
  # we can extract the method out into a shared class, maybe "AlbumAction" class
  # to call: AlbumAction.create_action(album_params) { |obj| authorize obj }
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

  def set_album
    @album = Album.find params[:id]
  end
end
