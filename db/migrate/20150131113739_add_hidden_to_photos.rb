class AddHiddenToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :hidden, :boolean
  end
end
