class ChangeMoodForLikes < ActiveRecord::Migration
  def change
    change_column :likes, :mood, :string
  end
end
