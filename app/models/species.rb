class Species < ActiveRecord::Base
  attr_accessible :name, :company_id
  has_many :products
  has_and_belongs_to_many :companies
  
  validates :name, :presence => true
  validates :name, :uniqueness => { :case_sensitive => true}
  
  validates :name, :length => { :maximum => 26 }
  
  # This query finds all the species of wood that have associated active products
  # within the data base.
  def self.active_product_species
    @species = Species.joins(:products).where('products.is_active' => 1).select("distinct(species.name)")
  end
  
end
