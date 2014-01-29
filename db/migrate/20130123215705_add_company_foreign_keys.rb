class AddCompanyForeignKeys < ActiveRecord::Migration
  def up
    change_table :employees do |t|
      t.integer :company_id
      t.foreign_key :companies
    end
    change_table :mailing_lists do |t|
      t.integer :company_id
      t.foreign_key :companies
    end
    change_table :products do |t|
      t.integer :company_id
      t.foreign_key :companies
    end
  end

  def down
    change_table :employees do |t|
      t.remove_foreign_key :companies
      t.remove :company_id
    end
    change_table :mailing_lists do |t|
      t.remove_foreign_key :companies
      t.remove :company_id
    end
    change_table :products do |t|
      t.remove_foreign_key :companies
      t.remove :company_id
    end
  end
end
