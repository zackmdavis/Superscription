require 'open-uri'
require 'nokogiri'

class Subscription < ActiveRecord::Base
  attr_accessible :url, :title, :update_frequency, :last_build_date

  validates :url, :title, :presence => true

  has_many :subscribers, :through => :user_subscriptions, :source => :user
  has_many :entries

  def load_entries!
    raw_feed = open(self.url)
    puts "Fetching feed ..."
    parsed_feed = Nokogiri::XML(raw_feed)
    puts "Got feed!"
    entries = []
    parsed_feed.xpath('//item').each do |item|
      item_attributes = {:title => item.xpath('title').text,
       :author => item.xpath('dc:creator').text,
       :url => item.xpath('link').text,
       :datetime => item.xpath('pubDate').text.to_datetime,
       :content => item.xpath('content:encoded').text,
       :subscription_id => self.id}
      entries.push(item_attributes)
      puts "Parsed attributes!"
    end
    entries.each do |entry_attributes|
      Entry.create(entry_attributes)
      puts "Saved item!"
    end
  end

end
