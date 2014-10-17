class User < ActiveRecord::Base
  has_many :created_albums, class_name: "Album", foreign_key: :creator_id

  has_many :album_relations, class_name: "UsersAlbums"
  has_many :joined_albums, -> { where("users_albums.access_type = ?", UsersAlbums::ACCESS_TYPE[:joined]) }, through: :album_relations, source: :album

  has_many :cover_images, as: :imageable, class_name: "Image"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def joins_album(album)
    UsersAlbums.create user: self, album: album, access_type: UsersAlbums::ACCESS_TYPE[:joined]
  end
end
