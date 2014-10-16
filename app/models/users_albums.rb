class UsersAlbums < ActiveRecord::Base
  ACCESS_TYPE = { creator: 1, access: 2, uploaded: 3, visited: 4 }

  belongs_to :user
  belongs_to :album
end
