class AddUnitReferenceToEployee < ActiveRecord::Migration
  def change
    change_table :employees do |t|
      t.references :unit
    end
  end
end
