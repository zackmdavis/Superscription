class Entry < ActiveRecord::Base
  attr_accessible :title, :author, :url, :datetime,
                  :subscription_id, :description, :content, :guid

  validates :title, :url, :datetime, :presence => true

  belongs_to :subscription
end
