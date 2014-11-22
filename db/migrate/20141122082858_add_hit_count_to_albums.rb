class AddHitCountToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :hit_count, :integer
  end
end
