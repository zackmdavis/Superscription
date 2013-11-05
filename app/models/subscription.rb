require 'open-uri'
require 'nokogiri'

class Subscription < ActiveRecord::Base
  attr_accessible :url, :title, :update_frequency, :last_build_date

  validates :url, :presence => true

  has_many :subscribers, :through => :user_subscriptions, :source => :user
  has_many :entries

  def load_entries!
    raw_feed = open(self.url)
    puts "Fetching feed ..."
    parsed_feed = Nokogiri::XML(raw_feed)
    puts "Got feed!"
    self.title = parsed_feed.xpath('//title').first.text
    declared_period = parsed_feed.xpath('//sy:updatePeriod').text
    declared_frequency = parsed_feed.xpath('//sy:updateFrequency').text.to_i
    self.update_frequency = update_frequency_in_seconds(declared_period, declared_frequency)
    self.last_build_date = parsed_feed.xpath('//lastBuildDate').text.to_datetime
    self.save
    entries = []
    parsed_feed.xpath('//item').each do |item|
      item_attributes = {:title => item.xpath('title').text,
       :author => item.xpath('dc:creator').text,
       :url => item.xpath('link').text,
       :datetime => item.xpath('pubDate').text.to_datetime,
       :description => item.xpath('description').text,
       :content => item.xpath('content:encoded').text,
       :guid => item.xpath('guid').text,
       :subscription_id => self.id}
      item_attributes.reject! { |key, value| value.is_a?(String) and value.empty? }
      entries.push(item_attributes)
      puts "Parsed attributes!"
    end
    entries.each do |entry_attributes|
      Entry.create(entry_attributes)
      puts "Saved item!"
    end
  end

  def update_frequency_in_seconds(period, frequency_in_periods)
    period_in_seconds = { 'hourly' => 3600, 'daily' => 86400, 'weekly' => 604800,
      'monthly' => 2419200, 'yearly' => 31449600}
    period_in_seconds[period] * frequency_in_periods
  end

end
