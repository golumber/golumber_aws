class CreateCompaniesSpeciesJoinTable < ActiveRecord::Migration
  def change
    create_table :companies_species, id: false do |t|
      t.integer :company_id
      t.integer :species_id
    end
  end
end
