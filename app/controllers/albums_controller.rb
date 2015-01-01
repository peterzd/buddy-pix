class AlbumsController < ApplicationController
  protect_from_forgery except: [ :hide_card, :view_card ]
  respond_to :html, :json, :js
  before_action :set_album, except: [:index, :hidden_cards, :following_cards, :following_cards_batch, :new, :create, :validate_name]

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
    @cards = AlbumsQuery.user_following_cards(current_user)
  end

  def following_cards_batch
    page = params[:page].to_i - 1
    @cards = AlbumsQuery.user_following_cards(current_user, page * AlbumsQuery::NUMBER_FACTOR)

    if @cards.empty?
      render nothing: true, status: 404
    else
      render partial: "albums/card_detail", collection: @cards, as: :card
    end
  end

  def show
    authorize @album
    @album.update hit_count: @album.hit_count + 1
    @photos = PhotosQuery.album_batch(@album)
    respond_with(@album)
  end

  def next_batch_photos
    page = params[:page].to_i - 1
    page = 1 if page == 0
    @photos = PhotosQuery.album_batch(@album, page * PhotosQuery::NUMBER_FACTOR)
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

  def validate_name
    name = params[:name]
    card = Album.find_by name: name
    if card
      render json: { status: false, card_url: card_path(card) }
    else
      render json: { status: true }
    end
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
      flash[:danger] = "this name is been taken. Please choose another one"
      render "new"
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
    @id = @album.id
    @album.destroy
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
  end

  def unfollow
    authorize @album
    current_user.unfollow_album @album
  end

  private
    def set_album
      @album = Album.find(params[:id])
    end

    def album_params
      params.require(:album).permit(:name, :private, :caption, { cover_image: [:picture] })
    end
end
