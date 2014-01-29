class RenameBfAndM3InProducts < ActiveRecord::Migration
  def change
    rename_column :products, :BF, :board_feet
    rename_column :products, :M3, :cubic_meters
  end
end
