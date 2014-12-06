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
    @cards = current_user.hidden_cards
  end

  def following_cards
    @cards = current_user.following_cards
  end

  def show
    authorize @album
    @album.update hit_count: @album.hit_count + 1
    @photos = @album.photos.order(updated_at: :desc).limit(3).offset(0)
    respond_with(@album)
  end

  def next_batch_photos
    page = params[:page].to_i - 1
    @photos = @album.photos.order(updated_at: :desc).limit(3).offset(page * 3)
    if @photos.empty?
      render nothing: true, status: 404
    else
      render partial: "photo", collection: @photos, locals: { from: "card" }
    end
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

    if AlbumsService.new(@album).save_album(album_params)
      redirect_to cards_path
    else
      render edit
    end
  end

  def update
    authorize @album
    @album.update(album_params.except(:cover_image))

    if album_params[:cover_image]
      AlbumsService.new(@album).update_cover(album_params)
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

  def publish_card
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
