# == Schema Information
#
# Table name: photos
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  description     :text
#  album_id        :integer
#  created_at      :datetime
#  updated_at      :datetime
#  creator_id      :integer
#  last_updater_id :integer
#  hidden          :boolean
#

require 'elasticsearch/model'

class Photo < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :images, as: :imageable, dependent: :destroy
  belongs_to :album, touch: true
  belongs_to :creator, class_name: "User"
  belongs_to :last_updater, class_name: "User"

  # relations with comments
  # has_many :comments, foreign_key: :commentable_id
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :commenter

  # relations with likes
  has_many :likes, foreign_key: :likeable_id, dependent: :destroy
  has_many :likers, through: :likes, source: :liker

  has_many :taggings, dependent: :destroy
  has_many :tagged_users, through: :taggings, source: :user

  default_scope { where(hidden: false).order(updated_at: :desc) }
  before_save :check_hidden

  class << self
    def all_visible_items
      includes(:album).where("albums.private" => [false, nil]).references(:albums)
    end

    def total_posts_per_day(date)
      posts = []
      all.each do |post|
        posts << post if post.created_at.to_date == date
      end
      posts
    end

    def total_posts_range(start_day, end_day)
      where(created_at: start_day.beginning_of_day..end_day.end_of_day)
    end
  end

  def first_image
    images.first
  end

  def picture_url(format=:original)
    return "" if images.empty?
    first_image.picture.url format
  end

  def recent_likes(count)
    likes.order(created_at: :desc).limit count
  end

  def update_last_updater(user)
    update last_updater: user
  end

  def commented_by(user, content: nil, image: nil)
    comment = Comment.create commenter: user, commentable: self, content: content, image: image
    after_action :comment, user
  end

  def liked_by(user, mood: Like::MOOD[:happy])
    return if user.liked_photos.include? self
    like = Like.create liker: user, likeable: self, mood: mood
    after_action :like, user
  end

  def updater
    return creator unless last_updater
    last_updater
  end

  def tag_user(user_id)
    user = User.find user_id
    return if tagged_users.include? user
    tagged_users << user
    send_notification(maker: creator, action: Notification::ACTION[:tagged], object: self, receiver: user)
  end

  def visible_to_world?
    album.visible_to_world?
  end

  private
  def send_notification(options={})
    Notification.create options
  end

  def after_action(action, user)
    touch
    update_last_updater user
    album.touch
    send_notification(maker: user, action: Notification::ACTION[action], object: self, receiver: creator) unless user == creator
  end

  def check_hidden
    self.hidden ||= false
    true
  end

end


