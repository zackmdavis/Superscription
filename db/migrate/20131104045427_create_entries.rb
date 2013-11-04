class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.string :author
      t.string :url
      t.datetime :date
      t.text :content
      t.integer :subscription_id
      t.timestamps
    end
    add_index :entries, :url
    add_index :entries, :subscription_id
  end
end
