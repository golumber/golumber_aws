class CompanySpecies < ActiveRecord::Migration
  def change
    create_table :company_species, :id => false do |t|
      t.integer :company_id
      t.integer :species_id
    end
    add_index(:company_species, [:company_id, :species_id], :unique => true)
  end
end
