class Entry < ActiveRecord::Base
  attr_accessible :title, :author, :url, :date, :content

  validates :title, :url, :datetime, :content, :presence => true

  belongs_to :subscription
end
