class AlbumsController < ApplicationController
  protect_from_forgery except: :hide_card
  respond_to :html, :json
  before_action :set_album, only: [:show, :edit, :update, :destroy, :hide_card]

  # Peter at 11.3: can the two methods extract the same code into another method?
  def index
    authorize :album, :index?
    @albums = policy_scope(current_user.created_albums)
    @user = current_user
    respond_with @albums
  end

  def hidden_cards
    authorize :album, :hidden_cards?
    @user = current_user
    @albums = current_user.hidden_cards
    respond_with @albums do |format|
      format.html { render :index }
    end
  end

  def show
    @user = current_user
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
    @album = Album.new(album_params.except(:cover_image).merge(creator: current_user))
    authorize @album
    @album.save

    if album_params[:cover_image]
      image = Image.create album_params[:cover_image]
      @album.set_cover_image image
    end

    redirect_to cards_path
  end

  def update
    @album.update(album_params)
    respond_with(@album)
  end

  def destroy
    @album.destroy
    respond_with(@album)
  end

  def hide_card
    authorize @album
    @album.update hidden: true
  end

  private
    def set_album
      @album = Album.find(params[:id])
    end

    def album_params
      params.require(:album).permit(:name, :private, :caption, { cover_image: [:picture] })
    end
end
