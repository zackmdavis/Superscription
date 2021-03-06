class Entry < ActiveRecord::Base
  attr_accessible :title, :author, :url, :datetime,
                  :description, :content, :guid, :subscription_id

  validates :title, :url, :datetime, :presence => true
  validates :description, :presence => true, :if => "content.nil?"

  belongs_to :subscription
  has_many :user_entry_readings, :dependent => :destroy
end
