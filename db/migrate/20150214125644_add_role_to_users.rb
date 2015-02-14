class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer
    remove_column :users, :type
  end
end
