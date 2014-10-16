class User < ActiveRecord::Base
  has_many :album_relations, class_name: "UsersAlbums"
  has_many :created_albums, -> { where("users_albums.access_type = 1") }, through: :album_relations, source: :album

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
