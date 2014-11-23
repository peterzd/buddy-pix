class Album < ActiveRecord::Base
  belongs_to :creator, class_name: "User"

  has_many :user_relations, class_name: "UsersAlbums"
  has_many :users, through: :user_relations
  has_many :followers, -> { where("users_albums.access_type = ?", UsersAlbums::ACCESS_TYPE[:joined]) }, through: :user_relations, source: :user

  # relations with images
  belongs_to :cover_image, class_name: "Image"
  has_many :photos

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

  private
  def set_default_value
    self.hidden ||= false
    self.hit_count ||= 0
  end

  def creator_follow
    creator.joins_album self
  end
end


