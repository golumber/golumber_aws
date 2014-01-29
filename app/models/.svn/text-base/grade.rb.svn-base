class Grade < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :products
  has_and_belongs_to_many :companies

  validates :name, :presence => true
  validates :name, :length => { :maximum => 20 }
  validates :description, :length => { :maximum => 100 }
  
  #employee is the current signed in employee record
  #****code needs to account for nil company attempting to view mygrades..
  def self.companies_grades(employee)
    comp_grades = CompaniesGrade.where(:company_id => employee.company_id)
    @grades ||= Array.new
    @grades.clear
    comp_grades.each do |grade|
      @grades.push(Grade.where(:id => grade.grade_id).first)
    end
    return @grades
  end

  def self.delete_companies_grade(employee,grade)
    @comp_grade = CompaniesGrade.where(:company_id => employee.company_id, :grade_id => grade.id).first
    return @comp_grade
  end
  
  def is_company_grade(employee)
    if self.default
      return false
    else
      comp_grade = CompaniesGrade.where(:company_id => employee.company_id, :grade_id => self.id)
      if comp_grade.blank?
        return false
      end
    end
  end
end
