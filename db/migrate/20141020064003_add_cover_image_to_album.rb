class AddCoverImageToAlbum < ActiveRecord::Migration
  def change
    add_reference :albums, :cover_image, index: true
  end
end
