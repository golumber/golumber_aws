class RemoveIsHardwoodFromGrades < ActiveRecord::Migration
  def up
    remove_column :grades, :is_hardwood
  end

  def down
    add_column :grades, :is_hardwood, :boolean
  end
end
