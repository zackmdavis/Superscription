class UserSubscription < ActiveRecord::Base
  attr_accessible :category_id, :subscription_id, :user_id

  belongs_to :category
  belongs_to :subscription, :inverse_of => :user_subscriptions
  has_many :entries, :through => :subscription
  belongs_to :user

  def url
    self.subscription.url
  end

  def title
    self.subscription.title
  end

  def unread_entries
    self.entries.includes(:subscription).joins("LEFT OUTER JOIN user_entry_readings ON entries.id = user_entry_readings.entry_id")
    .where("user_entry_readings.entry_id IS NULL OR user_entry_readings.user_id != #{self.user_id}")
  end

end
