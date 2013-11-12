class UserSubscription < ActiveRecord::Base
  attr_accessible :category_id, :subscription_id, :user_id

  # TODO investigate: this validation breaks the new subscription form
  #validates :subscription_id, :user_id, :presence => true

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
    user_readings_subquery = UserEntryReading.where(:user_id => self.user_id).to_sql
    self.entries.includes(:subscription).joins("LEFT OUTER JOIN (#{user_readings_subquery}) AS user_readings ON entries.id = user_readings.entry_id")
    .where("user_readings.entry_id IS NULL")
  end

end
