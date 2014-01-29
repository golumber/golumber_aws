class CompaniesGrade < ActiveRecord::Base
  attr_accessible :company_id, :grade_id
  belongs_to :company
  belongs_to :grade
end
