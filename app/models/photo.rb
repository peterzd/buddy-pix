require 'elasticsearch/model'

class Photo < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_one :image, as: :imageable, dependent: :destroy
  belongs_to :album, touch: true
  belongs_to :creator, class_name: "User"
  belongs_to :last_updater, class_name: "User"

  # relations with comments
  # has_many :comments, foreign_key: :commentable_id
  has_many :comments, as: :commentable
  has_many :commenters, through: :comments, source: :commenter

  # relations with likes
  has_many :likes, foreign_key: :likeable_id
  has_many :likers, through: :likes, source: :liker

  has_many :taggings
  has_many :tagged_users, through: :taggings, source: :user

  class << self
    def all_visible_items
      includes(:album).where("albums.private" => [false, nil]).references(:albums)
    end
  end

  def picture_url(format=:original)
    return "" if image.nil?
    image.picture.url format
  end

  def recent_likes(count)
    likes.order(created_at: :desc).limit count
  end

  def update_last_updater(user)
    update last_updater: user
  end

  def commented_by(user, content: nil, image: nil)
    comment = Comment.create commenter: user, commentable: self, content: content, image: image
    touch
    update_last_updater user
    album.touch
    send_notification(maker: user, action: Notification::ACTION[:comment], object: self, receiver: creator)
  end

  def updater
    return creator unless last_updater
    last_updater
  end

  def tag_user(user_id)
    user = User.find user_id
    return if tagged_users.include? user
    tagged_users << user
  end

  def visible_to_world?
    album.visible_to_world?
  end

  private
  def send_notification(options={})
    Notification.create options
  end
end


