class UserSubscription < ActiveRecord::Base
  attr_accessible :category_id, :subscription_id, :user_id

  belongs_to :category
  belongs_to :subscription
  belongs_to :user

  def url
    self.subscription.url
  end

  def title
    self.subscription.title
  end

end
