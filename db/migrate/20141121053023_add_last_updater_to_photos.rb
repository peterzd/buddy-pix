class AddLastUpdaterToPhotos < ActiveRecord::Migration
  def change
    add_reference :photos, :last_updater, index: true
  end
end
