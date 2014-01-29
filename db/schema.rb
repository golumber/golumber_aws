# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131207214308) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.string   "phone_number"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip_code"
    t.string   "is_admin"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "description"
    t.integer  "primary_photo_id"
  end

  create_table "companies_grades", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "grade_id"
  end

  create_table "companies_species", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "species_id"
  end

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "skype"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "unit_id"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.integer  "company_id"
  end

  add_index "employees", ["authentication_token"], :name => "index_employees_on_authentication_token", :unique => true
  add_index "employees", ["company_id"], :name => "employees_company_id_fk"
  add_index "employees", ["confirmation_token"], :name => "index_employees_on_confirmation_token", :unique => true
  add_index "employees", ["email"], :name => "index_employees_on_email", :unique => true
  add_index "employees", ["reset_password_token"], :name => "index_employees_on_reset_password_token", :unique => true
  add_index "employees", ["unit_id"], :name => "employees_unit_id_fk"

  create_table "grades", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "default",     :default => false
  end

  create_table "mailing_lists", :force => true do |t|
    t.string   "email"
    t.string   "contact_first"
    t.string   "contact_last"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "company_id"
  end

  add_index "mailing_lists", ["company_id"], :name => "mailing_lists_company_id_fk"

  create_table "photos", :force => true do |t|
    t.string   "caption"
    t.string   "photo"
    t.string   "imageable_type"
    t.integer  "imageable_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "products", :force => true do |t|
    t.boolean  "is_active"
    t.text     "details"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.integer  "company_id"
    t.decimal  "thickness_metric",      :precision => 4, :scale => 1
    t.text     "thickness_imperial"
    t.decimal  "thickness_actual",      :precision => 5, :scale => 3
    t.decimal  "width_metric",          :precision => 4, :scale => 1
    t.text     "width_imperial"
    t.decimal  "width_actual",          :precision => 5, :scale => 3
    t.decimal  "length_metric_lower",   :precision => 3, :scale => 1
    t.decimal  "length_metric_upper",   :precision => 3, :scale => 1
    t.decimal  "length_imperial_lower", :precision => 4, :scale => 2
    t.decimal  "length_imperial_upper", :precision => 4, :scale => 2
    t.decimal  "board_feet",            :precision => 6, :scale => 0
    t.decimal  "cubic_meters",          :precision => 8, :scale => 2
    t.integer  "primary_photo_id"
    t.integer  "grade_id"
    t.integer  "species_id"
    t.string   "region"
  end

  add_index "products", ["company_id"], :name => "products_company_id_fk"

  create_table "referrals", :force => true do |t|
    t.string   "referred_email"
    t.boolean  "joined",         :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "species", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "default",    :default => false
  end

  create_table "units", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_foreign_key "employees", "companies", name: "employees_company_id_fk"
  add_foreign_key "employees", "units", name: "employees_unit_id_fk"

  add_foreign_key "mailing_lists", "companies", name: "mailing_lists_company_id_fk"

  add_foreign_key "products", "companies", name: "products_company_id_fk"

end
