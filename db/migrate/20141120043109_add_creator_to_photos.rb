class AddCreatorToPhotos < ActiveRecord::Migration
  def change
    add_reference :photos, :creator, index: true
  end
end
