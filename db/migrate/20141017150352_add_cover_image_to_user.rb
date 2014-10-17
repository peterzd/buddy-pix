class AddCoverImageToUser < ActiveRecord::Migration
  def change
    add_reference :users, :cover_image, index: true
  end
end
