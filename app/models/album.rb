require 'elasticsearch/model'

class Album < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :creator, class_name: "User"

  has_many :user_relations, class_name: "UsersAlbums"
  has_many :users, through: :user_relations
  has_many :followers, -> { where("users_albums.access_type = ?", UsersAlbums::ACCESS_TYPE[:joined]) }, through: :user_relations, source: :user

  # relations with images
  belongs_to :cover_image, class_name: "Image"
  has_many :photos

  has_many :invitation_tokens, as: :action

  validates :name, uniqueness: true

  after_initialize :set_default_value
  after_save :creator_follow


  def set_cover_image(image)
    update cover_image_id: image.id
  end

  def cover_image_url(format=:original)
    cover_image ? cover_image.picture.url(format) : ""
  end

  def total_likes
    photos.inject(0) do |sum, photo|
      sum += photo.likers.count
    end
  end

  def total_comments
    photos.inject(0) do |sum, photo|
      sum += photo.commenters.count
    end
  end

  def recent_photos(count)
    photos.order(updated_at: :desc).limit(count)
  end

  def visible_to_world?
    return false if self.private? or self.hidden?
    true
  end

  def joined_by(user, send_noti=true)
    return if user.has_joined_album? self
    UsersAlbums.create user: user, album: self, access_type: UsersAlbums::ACCESS_TYPE[:joined]
    self.touch
    if send_noti
      send_notification(maker: user, action: Notification::ACTION[:join_card], object: self, receiver: creator)
    end
  end

  private
  def set_default_value
    self.hidden ||= false
    self.hit_count ||= 0
  end

  def creator_follow
    joined_by creator, false
  end

  def send_notification(options={})
    Notification.create options
  end
end


