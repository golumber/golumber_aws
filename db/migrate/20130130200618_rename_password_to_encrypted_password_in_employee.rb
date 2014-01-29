class RenamePasswordToEncryptedPasswordInEmployee < ActiveRecord::Migration
  def up
    change_table :employees do |t|
      t.rename :password, :encrypted_password
    end
  end

  def down
    change_table :employees do |t|
      t.rename :encrypted_password, :password
    end
  end
end
