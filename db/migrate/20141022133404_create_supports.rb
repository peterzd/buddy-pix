class CreateSupports < ActiveRecord::Migration
  def change
    create_table :supports do |t|
      t.string :sender_name
      t.string :email
      t.string :subject
      t.text :message

      t.timestamps
    end
  end
end
