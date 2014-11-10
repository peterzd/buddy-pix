class CreateUsersAlbums < ActiveRecord::Migration
  def change
    create_table :users_albums do |t|
      t.references :user, index: true
      t.references :album, index: true
      t.integer :access_type

      t.timestamps
    end
  end
end
