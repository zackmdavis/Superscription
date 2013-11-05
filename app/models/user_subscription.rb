class UserSubscription < ActiveRecord::Base
  attr_accessible :category_id, :subscription_id, :user_id

  belongs_to :subscription
  belongs_to :user

end
