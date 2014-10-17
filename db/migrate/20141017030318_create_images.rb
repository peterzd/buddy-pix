class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :picture

      t.timestamps
    end
  end
end
