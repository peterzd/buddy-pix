class AddIndexToProvider < ActiveRecord::Migration
  def change
    remove_index :users, :email
    add_index :users, [:email, :provider], unique: true
  end
end
