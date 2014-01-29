class Company < ActiveRecord::Base

  has_many :employees, :inverse_of => :company, :dependent => :destroy
  has_many :products, :dependent => :destroy
  has_many :mailing_lists, :dependent => :destroy
  has_many :photos, :as => :imageable, :dependent => :destroy
  belongs_to :primary_photo, :class_name => 'Photo'
  has_and_belongs_to_many :species
  has_and_belongs_to_many :grades
  
  accepts_nested_attributes_for :employees, :allow_destroy => true  
  accepts_nested_attributes_for :photos, :allow_destroy => true,
            :reject_if => proc {|attributes| attributes['filename'].blank? && attributes['filename_cache'].blank?}
  attr_accessible :tags_attributes, :employees, :street_address, :website, :zip_code, :id,
                  :city, :name, :country, :is_admin, :phone_number, :state, :description,
                  :primary_photo_id, :photos_attributes, :employees_attributes

  validates :name, :city, :country, :presence => true
  validates :name, :length => { :maximum => 30 }
  validates :description, :length => { :maximum => 250 }
  validates :city,:country,:state,:street_address, :length => { :maximum => 30 }
  validates :zip_code, :length => { :maximum => 10 }
  #validates :phone_number, :length => { :maximum => 10 }

  
  # returns html for the thumbnail for this company's primary photo
  # @return: a tag containing the thumbnail for this company's primary photo
  def primary_photo_thumbnail
    if !primary_photo.nil?
      primary_photo.thumbnail_tag(:small_thumbnail)
    else
      Photo.default_thumbnail
    end      
  end
  
  def self.current
    Thread.current[:company]
  end
  def self.current=(user)
    Thread.current[:company] = user
  end
end
