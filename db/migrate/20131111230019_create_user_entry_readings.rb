class CreateUserEntryReadings < ActiveRecord::Migration
  def change
    create_table :user_entry_readings do |t|
      t.integer :user_id
      t.integer :entry_id

      t.timestamps
    end
  end
end
