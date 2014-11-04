class User < ActiveRecord::Base
  has_many :created_albums, class_name: "Album", foreign_key: :creator_id

  has_many :album_relations, class_name: "UsersAlbums"
  has_many :joined_albums, -> { where("users_albums.access_type = ?", UsersAlbums::ACCESS_TYPE[:joined]) }, through: :album_relations, source: :album

  # relations with images
  has_many :cover_images, as: :imageable, class_name: "Image"
  belongs_to :profile_cover, class_name: "Image", foreign_key: :cover_image_id
  belongs_to :cover_photo, class_name: "Image", foreign_key: :cover_photo_id

  # relations with comments
  has_many :comments, foreign_key: :commenter_id
  has_many :commented_images, through: :comments, source: :commentable

  # relations with like
  has_many :likes, foreign_key: :liker_id
  has_many :liked_photos, through: :likes, source: :likeable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def admin?
    instance_of? AdminUser
  end

  def joins_album(album)
    UsersAlbums.create user: self, album: album, access_type: UsersAlbums::ACCESS_TYPE[:joined]
  end

  def hidden_cards
    created_albums.where hidden: true
  end

  def set_profile_cover(image)
    cover_images << image unless cover_images.include?(image)
    update cover_image_id: image.id
  end

  def set_cover_photo(image)
    cover_images << image unless cover_images.include?(image)
    update cover_photo_id: image.id
  end

  def like_photo(photo, mood: Like::MOOD[:happy])
    like = Like.create liker: self, likeable: photo, mood: mood
  end

  def profile_cover_url(format=:original)
    return "" if profile_cover.nil?
    profile_cover.picture.url(format)
  end

  def cover_photo_url(format=:original)
    return "" if cover_photo.nil?
    cover_photo.picture.url(format)
  end

  def show_name
    return email if first_name.nil?
    first_name
  end

  def user_name
    "#{first_name} #{last_name}"
  end

  def total_photos
    created_albums.inject([]) do |total_photos, album|
      if album.photos
        total_photos << album.photos
      else
        total_photos
      end
    end
    .flatten
  end

  # Peter at 11.3: these total methods are the same with the ones in model/album.rb
  # maybe we can extract them out into another file
  def total_likes
    total_photos.inject(0) do |sum, image|
      sum += image.likers.count
    end
  end

  def total_comments
    total_photos.inject(0) do |sum, image|
      sum += image.commenters.count
    end
  end
end

