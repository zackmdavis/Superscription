class Entry < ActiveRecord::Base
  attr_accessible :title, :author, :url, :datetime, :subscription_id, :content

  validates :title, :url, :datetime, :content, :presence => true

  belongs_to :subscription
end
