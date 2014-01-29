class CompanyGrade < ActiveRecord::Migration
  def change
    create_table :company_grades, :id => false do |t|
      t.integer :company_id
      t.integer :grade_id
      t.boolean :default, :default => false
    end
    add_index(:company_grades, [:company_id, :grade_id], :unique => true)
  end
end
