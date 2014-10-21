class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  has_one :covered_user, class_name: "User", foreign_key: :cover_image_id
  has_one :covered_album, class_name: "Album", foreign_key: :cover_image_id

  # relations with comments
  has_many :comments, foreign_key: :commentable_id
  has_many :commenters, through: :comments, source: :commenter

  # relations with likes
  has_many :likes, foreign_key: :likeable_id
  has_many :likers, through: :likes, source: :liker

  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
end
