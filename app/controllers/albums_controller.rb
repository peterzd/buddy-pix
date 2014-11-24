class AlbumsController < ApplicationController
  protect_from_forgery except: [ :hide_card, :view_card ]
  respond_to :html, :json
  before_action :set_album, except: [:index, :hidden_cards, :following_cards, :new, :create]

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

  def following_cards
    @cards = current_user.following_cards
  end

  def show
    authorize @album
    @album.update hit_count: @album.hit_count + 1
    @photos = @album.photos.order updated_at: :desc
    respond_with(@album)
  end

  def new
    @album = Album.new
    authorize @album
    respond_with(@album)
  end

  def edit
    authorize @album
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
    authorize @album
    @album.update(album_params.except(:cover_image))

    if album_params[:cover_image]
      image = Image.create album_params[:cover_image]
      @album.set_cover_image image
    end
    redirect_to card_path @album
  end

  def destroy
    @album.destroy
    respond_with(@album)
  end

  def hide_card
    authorize @album
    @album.update hidden: true
    respond_with @album do |format|
      format.js { render "hide_view_card" }
    end
  end

  def view_card
    @album.update hidden: false
    respond_with @album do |format|
      format.js { render "hide_view_card" }
    end
  end

  def follow
    authorize @album
    current_user.joins_album @album
    redirect_to card_path @album
  end

  def unfollow
    authorize @album
    current_user.unfollow_album @album
    if params[:from] and params[:from] == "following_page"
      redirect_to following_cards_cards_path
    else
      redirect_to card_path @album
    end
  end

  private
    def set_album
      @album = Album.find(params[:id])
    end

    def album_params
      params.require(:album).permit(:name, :private, :caption, { cover_image: [:picture] })
    end
end
