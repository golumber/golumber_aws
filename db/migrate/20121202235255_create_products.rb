class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.boolean :is_active
      t.integer :thickness
      t.integer :width
      t.text :details
      t.integer :length

      t.timestamps
    end
  end
end
