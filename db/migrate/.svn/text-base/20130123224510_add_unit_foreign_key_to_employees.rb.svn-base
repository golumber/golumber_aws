class AddUnitForeignKeyToEmployees < ActiveRecord::Migration
  def up
    change_table :employees do |t|
      t.foreign_key :units
    end
  end
  
  def down
    change_table :employees do |t|
     t.remove_foreign_key :units
    end    
  end
end
