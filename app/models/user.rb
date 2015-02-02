class User < ActiveRecord::Base
  has_many :created_albums, class_name: "Album", foreign_key: :creator_id, dependent: :destroy
  has_many :uploaded_photos, class_name: "Photo", foreign_key: :creator_id, dependent: :destroy

  has_many :album_relations, class_name: "UsersAlbums", dependent: :destroy
  has_many :joined_albums, -> { where("users_albums.access_type = ?", UsersAlbums::ACCESS_TYPE[:joined]) }, through: :album_relations, source: :album

  # relations with images
  has_many :cover_images, as: :imageable, class_name: "Image"
  belongs_to :profile_cover, class_name: "Image", foreign_key: :cover_image_id
  belongs_to :cover_photo, class_name: "Image", foreign_key: :cover_photo_id

  # relations with comments
  has_many :comments, foreign_key: :commenter_id
  has_many :commented_images, through: :comments, source: :commentable, source_type: "Photo"

  # relations with like
  has_many :likes, foreign_key: :liker_id, dependent: :destroy
  has_many :liked_photos, through: :likes, source: :likeable

  # invitations
  has_many :received_invitations, class_name: "Invitation", foreign_key: :receiver_id
  has_many :sent_invitaions, class_name: "Invitation", foreign_key: :sender_id, dependent: :destroy

  has_many :taggings
  has_many :tagged_photos, through: :taggings, source: :photo

  has_many :notifications, foreign_key: :receiver_id
  has_many :sent_notifications, class_name: "Notification", foreign_key: :maker_id, dependent: :destroy

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  before_save :ensure_authentication_token

  class << self
    def all_users
      where(type: nil).all
    end

    def all_other_users(myself)
      User.where(type: nil).where.not(id: myself.id)
    end

    # copied from [devise wiki](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview),
    # for omniauth login
    def from_omniauth(auth)
      user = where(email: auth.info.email).first
      if user.nil?
        user = User.new email: auth.info.email,
                        password: Devise.friendly_token[0,20],
                        first_name: auth.info.first_name,
                        last_name: auth.info.last_name,
                        username: auth.info.username,   # assuming the user model has a name
                        image_url: auth.info.image # assuming the user model has an image
        user.skip_confirmation!
        user.save!
      end
      user
    end

    def find_for_google_oauth2(auth)
      user = where(email: auth.info.email).first
      if user.nil?
        user = User.new email: auth.info.email,
                        password: Devise.friendly_token[0,20],
                        first_name: auth.info.first_name,
                        last_name: auth.info.last_name,
                        username: auth.info.name,
                        image_url: auth.info.image
        user.skip_confirmation!
        user.save!
      end
      user
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        elsif data = session["devise.google_data"] && session["devise.google_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end

    def registered_per_day(date)
      all_user = []
      User.all.each do |u|
        all_user << u if u.created_at.to_date == date
      end
      all_user
    end

    def active_users_per_day(date)
      where(current_sign_in_at: date.beginning_of_day..date.end_of_day)
    end

    def inactive_users
      users = []
      order(:id).all.each do |user|
        users << user if (user.last_sign_in_at.nil? ) or (user.last_sign_in_at.to_date - Date.today > 13)
      end
      users
    end

  end # end of class methods
  
  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def admin?
    instance_of? AdminUser
  end

  def joins_album(album)
    album.joined_by(self)
  end

  def following_cards
    joined_albums
  end

  def unfollow_album(album)
    joined_albums.delete album
  end

  def has_joined_album?(album)
    joined_albums.include? album
  end

  def profile_cards
    joined_albums.order(updated_at: :desc)
  end

  def my_wall_pics
    PhotosQuery.user_wall_pics(self)
  end

  def comments_photo(photo, comment_content="", image=nil)
    photo.commented_by self, content: comment_content, image: image
  end

  def reply_comment(comment, reply_content="", image=nil)
    Comment.create commenter: self, commentable: comment, content: reply_content, image: image
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
    photo.liked_by self, mood: mood
  end

  def profile_cover_url(format=:original)
    return "imgo.jpg" if (profile_cover.nil? or profile_cover.picture_file_name.nil?) and image_url.nil?
    return image_url if profile_cover.nil?
    profile_cover.picture.url(format)
  end

  def cover_photo_url(format=:original)
    return nil if cover_photo.nil?
    cover_photo.picture.url(format)
  end

  def show_name
    return email if first_name.nil?
    first_name
  end

  def user_name
    username || "#{first_name} #{last_name}"
  end

  # peter at 2014-11-20: this method may not be used
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
    uploaded_photos.inject(0) do |sum, image|
      sum += image.likers.count
    end
  end

  def total_comments
    uploaded_photos.inject(0) do |sum, image|
      sum += image.commenters.count
    end
  end

  def last_sign_in_date
    date = last_sign_in_at || created_at
  end

  def send_invitation(receiver_id, card)
    user = User.find receiver_id
    return if user.my_pending_invited_cards.include? card
    Invitation.create sender: self, receiver_id: receiver_id, card: card, status: Invitation::STATUS[:pending]
  end

  def my_pending_invitations
    received_invitations.where status: Invitation::STATUS[:pending]
  end

  def my_rejected_invitations
    received_invitations.where status: Invitation::STATUS[:rejected]
  end

  def my_pending_invited_cards
    my_pending_invitations.inject([]) do |invited_cards, invitation|
      invited_cards << invitation.card
    end
  end

  def unread_notifications
    notifications.where(is_read: false).order(created_at: :desc)
  end

  def alerts_count
    my_pending_invitations.count + unread_notifications.count
  end

  # for reports
  def created_cards_per_day(date)
    created_albums.where(created_at: date.beginning_of_day..date.end_of_day)
  end

  def created_private_cards_per_day(date)
    created_cards_per_day(date).where(private: true)
  end

  def created_public_cards_per_day(date)
    created_cards_per_day(date).where(private: [nil, false])
  end

  def created_posts_per_day(date)
    uploaded_photos.where(created_at: date.beginning_of_day..date.end_of_day)
  end

  def created_comments_per_day(date)
    comments.where(created_at: date.beginning_of_day..date.end_of_day)
  end

  def created_likes_per_day(date)
    likes.where(created_at: date.beginning_of_day..date.end_of_day)
  end

  private
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end

