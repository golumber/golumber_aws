class RemoveDescFromSpecies < ActiveRecord::Migration
  def change
    remove_column :species, :description
  end
end
