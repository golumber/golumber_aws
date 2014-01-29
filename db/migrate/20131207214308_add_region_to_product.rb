class AddRegionToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :region, :string
  end
end
