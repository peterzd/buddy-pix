class Album < ActiveRecord::Base
  has_many :user_relations, class_name: "UsersAlbums"
  has_many :users, through: :user_relations
end
