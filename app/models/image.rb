class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  has_one :covered_user, class_name: "User", foreign_key: :cover_image_id
  has_one :covered_album, class_name: "Album", foreign_key: :cover_image_id

  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
end
