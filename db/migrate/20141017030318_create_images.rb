class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :picture
      t.references :imageable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
