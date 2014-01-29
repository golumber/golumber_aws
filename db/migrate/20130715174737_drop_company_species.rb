class DropCompanySpecies < ActiveRecord::Migration
  def change
    drop_table :company_species
  end
end
