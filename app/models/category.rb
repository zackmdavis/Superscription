class Category < ActiveRecord::Base
  attr_accessible :name, :user_id

  validates :name, :user_id, :presence => true

  belongs_to :user
  has_many :user_subscriptions
  has_many :subscriptions, :through => :user_subscriptions

end
