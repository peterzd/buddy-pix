class UsersAlbums < ActiveRecord::Base
  ACCESS_TYPE = { joined: 1, uploaded: 2, visited: 3 }

  belongs_to :user
  belongs_to :album
end
