class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :commenter, index: true
      t.references :commentable, index: true
      t.text :content

      t.timestamps
    end
  end
end
