class RedoCompaniesSpecies < ActiveRecord::Migration
    def change
      create_table :companies_species do |t|
        t.integer :company_id
        t.integer :species_id
      end
      add_index(:companies_species, [:company_id, :species_id], :unique => true)
    end
  end
