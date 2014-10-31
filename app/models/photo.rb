class Photo < ActiveRecord::Base
  has_one :image, as: :imageable
  belongs_to :album

  # relations with comments
  has_many :comments, foreign_key: :commentable_id
  has_many :commenters, through: :comments, source: :commenter

  # relations with likes
  has_many :likes, foreign_key: :likeable_id
  has_many :likers, through: :likes, source: :liker
end
