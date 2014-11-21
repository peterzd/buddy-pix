class Comment < ActiveRecord::Base
  belongs_to :commenter, class_name: "User", foreign_key: :commenter_id
  belongs_to :commentable, class_name: "Photo", foreign_key: :commentable_id

  has_one :image, as: :imageable, dependent: :destroy

  def picture_url(format=:original)
    return "" if image.nil?
    image.picture.url format
  end
end

