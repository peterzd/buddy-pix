class Photo < ActiveRecord::Base
  has_one :image, as: :imageable
  belongs_to :album, touch: true
  belongs_to :creator, class_name: "User"

  # relations with comments
  has_many :comments, foreign_key: :commentable_id
  has_many :commenters, through: :comments, source: :commenter

  # relations with likes
  has_many :likes, foreign_key: :likeable_id
  has_many :likers, through: :likes, source: :liker

  def picture_url(format=:original)
    return "" if image.nil?
    image.picture.url format
  end

  def recent_likes(count)
    likes.order(created_at: :desc).limit count
  end
end
