class DropCompanyGrades < ActiveRecord::Migration
  def change
    drop_table :company_grades
  end
end
