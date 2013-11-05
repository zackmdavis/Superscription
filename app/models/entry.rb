class Entry < ActiveRecord::Base
  attr_accessible :title, :author, :url, :datetime,
                  :description, :content, :guid, :subscription_id

  validates :title, :url, :datetime, :presence => true

  belongs_to :subscription
end
