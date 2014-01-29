class AddDefaultFlagToSpecies < ActiveRecord::Migration
  def change
    add_column :species, :default, :boolean, :default => false
  end
end
