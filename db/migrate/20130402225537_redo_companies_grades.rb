class RedoCompaniesGrades < ActiveRecord::Migration
  def change
    create_table :companies_grades do |t|
      t.integer :company_id
      t.integer :grade_id
    end
    add_index(:companies_grades, [:company_id, :grade_id], :unique => true)
  end
end

