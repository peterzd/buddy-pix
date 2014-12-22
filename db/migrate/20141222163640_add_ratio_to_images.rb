class AddRatioToImages < ActiveRecord::Migration
  def change
    add_column :images, :ratio, :float
  end
end
