class Subscription < ActiveRecord::Base
  attr_accessible :url, :title, :user_id, :category_id

  validates :url, :title, :presence => true

end
