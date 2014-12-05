class RemoveProviderFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, [:email, :provider]
    add_index :users, :email, unique: true
  end
end
