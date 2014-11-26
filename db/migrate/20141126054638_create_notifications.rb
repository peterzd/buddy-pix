class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :maker, index: true
      t.string :action
      t.references :object, polymorphic: true, index: true
      t.references :receiver, index: true

      t.timestamps
    end
  end
end
