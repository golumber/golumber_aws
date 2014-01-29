class CreateCompaniesGradesJoinTable < ActiveRecord::Migration
  def change
    create_table :companies_grades, id: false do |t|
      t.integer :company_id
      t.integer :grade_id
    end
  end
end
