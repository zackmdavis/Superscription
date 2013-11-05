class EditSubscriptionSchema < ActiveRecord::Migration

  def change
    add_column :subscriptions, :update_frequency, :integer
    add_column :subscriptions, :last_build_date, :datetime
    remove_column :subscriptions, :user_id
    remove_column :subscriptions, :category_id
  end

end
