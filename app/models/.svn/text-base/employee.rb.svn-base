class Employee < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable and :omniauthable
  devise :token_authenticatable, :confirmable, :database_authenticatable,
         :registerable, :recoverable, :rememberable, :trackable, :validatable
         
  belongs_to :company, :inverse_of => :employees

  # Setup accessible (or protected) attributes for your model
  attr_accessible :company_id, :first_name, :last_name, :phone_number, :skype
  attr_accessible :remember_me, :password, :password_confirmation
  attr_accessible :email, :email_confirmation
  
  validates :first_name,  :presence => true
  validates :last_name,   :presence => true
  validates :email, :confirmation => true

  validates_exclusion_of :password, :in => lambda { |p| [p.email] },
                         :message => "Password should not be the same as email."

  # Determines if the company information being viewed belongs to the current user
  # @param company_id is the id of the company that the user is attempting to access                      
  def can_manage?(company_id)
    return self[:company_id].to_i == company_id.to_i
  end
end