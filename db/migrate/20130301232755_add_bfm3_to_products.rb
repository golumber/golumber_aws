class AddBfm3ToProducts < ActiveRecord::Migration
  def change
    add_column :products, :BF_M3, :integer
  end
    
end
