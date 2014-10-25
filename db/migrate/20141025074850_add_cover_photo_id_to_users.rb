class AddCoverPhotoIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :cover_photo, index: true
  end
end
