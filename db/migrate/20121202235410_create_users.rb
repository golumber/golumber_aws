class CreateUsers < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :website
      t.string :phone_number
      t.string :street_address
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.string :is_admin

      t.timestamps
    end
  end
end
