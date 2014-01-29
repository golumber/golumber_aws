class RemoveIsHardwoodFromSpecies < ActiveRecord::Migration
  def up
    remove_column :species, :is_hardwood
  end

  def down
    add_column :species, :is_hardwood, :boolean
  end
end
