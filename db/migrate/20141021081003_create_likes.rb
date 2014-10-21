class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :liker, index: true
      t.integer :mood
      t.references :likeable, index: true

      t.timestamps
    end
  end
end
