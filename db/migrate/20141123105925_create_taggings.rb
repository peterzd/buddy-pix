class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :photo, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
