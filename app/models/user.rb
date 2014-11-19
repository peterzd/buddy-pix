class User < ActiveRecord::Base
  has_many :created_albums, class_name: "Album", foreign_key: :creator_id

  has_many :album_relations, class_name: "UsersAlbums"
  has_many :joined_albums, -> { where("users_albums.access_type = ?", UsersAlbums::ACCESS_TYPE[:joined]) }, through: :album_relations, source: :album

  # relations with images
  has_many :cover_images, as: :imageable, class_name: "Image"
  belongs_to :profile_cover, class_name: "Image", foreign_key: :cover_image_id
  belongs_to :cover_photo, class_name: "Image", foreign_key: :cover_photo_id

  # relations with comments
  has_many :comments, foreign_key: :commenter_id
  has_many :commented_images, through: :comments, source: :commentable

  # relations with like
  has_many :likes, foreign_key: :liker_id
  has_many :liked_photos, through: :likes, source: :likeable

  # invitations
  has_many :received_invitations, class_name: "Invitation", foreign_key: :receiver_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_authentication_token

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def admin?
    instance_of? AdminUser
  end

  def joins_album(album)
    UsersAlbums.create user: self, album: album, access_type: UsersAlbums::ACCESS_TYPE[:joined]
    album.touch
  end

  def profile_cards
    joined_albums.order(updated_at: :desc)
  end

  def comments_photo(photo, comment_content="")
    commented_images << photo
    comments.last.update content: comment_content
    photo.album.touch
  end

  def hidden_cards
    created_albums.where hidden: true
  end

  def set_profile_cover(image)
    cover_images << image unless cover_images.include?(image)
    update cover_image_id: image.id
  end

  def set_cover_photo(image)
    cover_images << image unless cover_images.include?(image)
    update cover_photo_id: image.id
  end

  def like_photo(photo, mood: Like::MOOD[:happy])
    like = Like.create liker: self, likeable: photo, mood: mood
    photo.album.touch
  end

  def profile_cover_url(format=:original)
    return "" if profile_cover.nil?
    profile_cover.picture.url(format)
  end

  def cover_photo_url(format=:original)
    return "" if cover_photo.nil?
    cover_photo.picture.url(format)
  end

  def show_name
    return email if first_name.nil?
    first_name
  end

  def user_name
    "#{first_name} #{last_name}"
  end

  def total_photos
    created_albums.inject([]) do |total_photos, album|
      if album.photos
        total_photos << album.photos
      else
        total_photos
      end
    end
    .flatten
  end

  # Peter at 11.3: these total methods are the same with the ones in model/album.rb
  # maybe we can extract them out into another file
  def total_likes
    total_photos.inject(0) do |sum, image|
      sum += image.likers.count
    end
  end

  def total_comments
    total_photos.inject(0) do |sum, image|
      sum += image.commenters.count
    end
  end

  def last_sign_in_date
    date = last_sign_in_at || created_at
  end

  def send_invitation(receiver_id, card)
    Invitation.create sender: self, receiver_id: receiver_id, card: card, status: Invitation::STATUS[:pending]
  end

  def my_pending_invitations
    received_invitations.where status: Invitation::STATUS[:pending]
  end
  
  private
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end

