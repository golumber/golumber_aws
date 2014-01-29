class AddPrimaryPhotoToProducts < ActiveRecord::Migration
  def change
    add_column :products, :primary_photo_id, :integer 
  end
end
