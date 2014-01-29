class AddDefaultToGrade < ActiveRecord::Migration
  def change
    add_column :grades, :default, :boolean, :default => false
  end
end
