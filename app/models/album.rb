class Album < ActiveRecord::Base
  belongs_to :creator, class_name: "User"

  has_many :user_relations, class_name: "UsersAlbums"
  has_many :users, through: :user_relations
  has_many :followers, -> { where("users_albums.access_type = ?", UsersAlbums::ACCESS_TYPE[:joined]) }, through: :user_relations, source: :user


  # relations with images
  belongs_to :cover_image, class_name: "Image"
  has_many :images, as: :imageable, class_name: "Image"

  def set_cover_image(image)
    update cover_image_id: image.id
  end

  def cover_image_url(format=:original)
    cover_image ? cover_image.picture.url(format) : ""
  end

  def total_likes
    images.inject(0) do |sum, image|
      sum += image.likers.count
    end
  end

  def total_comments
    images.inject(0) do |sum, image|
      sum += image.commenters.count
    end
  end
end
