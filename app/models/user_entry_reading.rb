class UserEntryReading < ActiveRecord::Base
  attr_accessible :entry_id, :user_id

  validates :entry_id, :user_id, :presence => true
  validates :entry_id, :uniqueness => {:scope => :user_id}

end
