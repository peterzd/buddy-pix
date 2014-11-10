class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.boolean :private
      t.text :caption
      t.references :creator, index: true

      t.timestamps
    end
  end
end
