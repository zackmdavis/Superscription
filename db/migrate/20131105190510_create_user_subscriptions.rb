class CreateUserSubscriptions < ActiveRecord::Migration
  def change
    create_table :user_subscriptions do |t|
      t.integer :user_id
      t.integer :subscription_id
      t.integer :category_id

      t.timestamps
    end
    add_index :user_subscriptions, :user_id
    add_index :user_subscriptions, :subscription_id
    add_index :user_subscriptions, :category_id
  end
end
