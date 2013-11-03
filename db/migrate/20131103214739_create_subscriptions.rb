class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :url
      t.string :title
      t.integer :user_id
      t.integer :category_id

      t.timestamps
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, :category_id
  end
end
