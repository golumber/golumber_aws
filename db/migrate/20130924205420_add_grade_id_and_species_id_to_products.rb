class AddGradeIdAndSpeciesIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :grade_id, :integer
    add_column :products, :species_id, :integer
  end
end
