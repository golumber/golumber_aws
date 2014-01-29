class Photo < ActiveRecord::Base
  
  belongs_to :imageable, :polymorphic => true
  has_one :product
  has_one :company
  
  attr_accessible :caption, :photo, :imageable_type, :imageable_id
   
  after_commit :remove_directory, on: :destroy
  after_commit :reset_primary_photo_id, on: :destroy
  after_commit :set_primary_photo_id, on: :create
  
  mount_uploader :photo, PhotoUploader
  
  def thumbnail_tag(version = :small_thumbnail)
    ActionController::Base.helpers.image_tag(photo_url(version).to_s)
  end

  def image=(val)
    if !val.is_a?(String) && valid?
      image_will_change!
      super
    end
  end
  
  # returns an image tag containing a thumbnail of the default photo
  def self.default_thumbnail
    ActionController::Base.helpers.image_tag("noIMGavail.png")
  end

  private
  
  # deletes the folder which contained this photo after the record is destroyed
  def remove_directory
      FileUtils.remove_dir("#{Rails.root}/public/uploads/photo/photo/#{id}", :force => true)
  end
  
  # resets the imageable's primary_photo_id if the destroyed photo was the primary photo
  def reset_primary_photo_id
    if imageable.primary_photo_id = id
      if imageable.photos.empty?
        imageable.update_attribute(:primary_photo_id, nil)
      else
        imageable.update_attribute(:primary_photo_id, imageable.photos.first.id)
      end
    end
  end
  
  # sets the imageable's primary_photo_id to the new photo's id if the product didn't already have a primary photo
  def set_primary_photo_id
    if imageable.primary_photo_id.nil?
      imageable.update_attribute(:primary_photo_id, id)
    end
  end
end
