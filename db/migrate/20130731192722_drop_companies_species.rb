class DropCompaniesSpecies < ActiveRecord::Migration
  def change
    drop_table :companies_species
  end
end
