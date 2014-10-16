class Album < ActiveRecord::Base
  belongs_to :creator, class_name: "User"

  has_many :user_relations, class_name: "UsersAlbums"
  has_many :users, through: :user_relations
  has_many :followers, -> { where("users_albums.access_type = ?", UsersAlbums::ACCESS_TYPE[:joined]) }, through: :user_relations, source: :user

end
