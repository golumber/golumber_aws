class AddPrimaryPhotoToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :primary_photo_id, :integer
  end
end
