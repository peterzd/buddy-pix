class User < ActiveRecord::Base
  has_many :created_albums, class_name: "Album", foreign_key: :creator_id

  has_many :album_relations, class_name: "UsersAlbums"
  has_many :access_albums, -> { where("users_albums.access_type = ?", UsersAlbums::ACCESS_TYPE[:access]) }, through: :album_relations, source: :album

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
