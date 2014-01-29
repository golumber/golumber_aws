class MailingList < ActiveRecord::Base
  attr_accessible :company_id, :contact_first, :contact_last, :email
  belongs_to :company
  
  validates :company_id, :presence => true
  validates :email,      :presence => true,
                         :length => { :minimum => 5 }
end
