require 'open-uri'
require 'nokogiri'

class Subscription < ActiveRecord::Base
  attr_accessible :url, :title, :update_frequency, :last_build_date

  validates :url, :presence => true

  has_many :subscribers, :through => :user_subscriptions, :source => :user
  has_many :entries

  def parsed_feed
    @parsed_feed ||= fetch_feed
  end

  def fetch_feed
    raw_feed = open(self.url)
    puts "Fetching feed ..."
    parsed_feed = Nokogiri::XML(raw_feed)
    puts "Got and parsed feed!"
    parsed_feed
  end

  def load_everything!
    load_info!
    load_entries!
  end

  def load_info!
    feed = self.parsed_feed
    self.title = feed.xpath('//title').first.text
    # Why isn't "begin/rescue" catching the error?! TODO: read up on the RSS
    # standard and do a proper conditional
    begin
      update_period_unit = feed.xpath('//sy:updatePeriod').text
      update_period = feed.xpath('//sy:updateFrequency').text.to_i
      self.update_frequency = update_period_in_seconds(update_period_unit, update_period)
      self.last_build_date = feed.xpath('//lastBuildDate').text.to_datetime
    rescue SyntaxError
      self.update_frequency = 300
      self.last_build_date = DateTime.now
    end
    self.save
  end

  def load_entries!
    # TODO: only load new entries rather than wastefully reloading all of them
    self.entries.delete_all
    feed = self.parsed_feed
    entries = []
    feed.xpath('//item').each do |item|
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

  def update_period_in_seconds(period_units, period_in_units)
    unit_in_seconds = { 'hourly' => 3600, 'daily' => 86400, 'weekly' => 604800,
      'monthly' => 2419200, 'yearly' => 31449600}
    unit_in_seconds[period_units] * period_in_units
  end

end
