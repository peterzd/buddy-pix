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

  end
end
