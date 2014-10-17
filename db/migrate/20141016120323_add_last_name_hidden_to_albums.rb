class AddLastNameHiddenToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :last_name, :string
    add_column :albums, :hidden, :boolean
  end
end
