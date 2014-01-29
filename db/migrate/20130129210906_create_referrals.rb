class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.string :referred_email
      t.boolean :joined, :default => false

      t.timestamps
    end
  end
end
