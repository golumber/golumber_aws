class CreateSpecies < ActiveRecord::Migration
  def change
    create_table :species do |t|
      t.string :name
      t.text :description
      t.boolean :is_hardwood

      t.timestamps
    end
  end
end
