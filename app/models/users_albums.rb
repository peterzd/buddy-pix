# == Schema Information
#
# Table name: users_albums
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  album_id    :integer
#  access_type :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class UsersAlbums < ActiveRecord::Base
  ACCESS_TYPE = { joined: 1, uploaded: 2, visited: 3 }

  belongs_to :user
  belongs_to :album
end
