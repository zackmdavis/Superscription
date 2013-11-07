require 'open-uri'
require 'nokogiri'

class Subscription < ActiveRecord::Base
  attr_accessible :url, :title, :update_frequency, :last_build_date, :user_subscriptions_attributes

  validates :url, :presence => true

  has_many :user_subscriptions, :inverse_of => :subscription
  has_many :subscribers, :through => :user_subscriptions, :source => :user
  has_many :entries

  accepts_nested_attributes_for :user_subscriptions

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
    update_frequency_unit = feed.xpath('//sy:updatePeriod', "sy" => "http://purl.org/rss/1.0/modules/syndication/").text
    update_frequency = feed.xpath('//sy:updateFrequency', "sy" => "http://purl.org/rss/1.0/modules/syndication/").text.to_i
    if update_frequency != 0
      self.update_frequency = update_frequency_in_seconds(update_frequency_unit, update_frequency)
    else
      self.update_frequency = 300
    end
    last_build_date = feed.xpath('//lastBuildDate').text.to_datetime
    if last_build_date
      self.last_build_date = last_build_date
    else
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
       :author => item.xpath('dc:creator', "dc" => "http://purl.org/dc/elements/1.1/").text,
       :url => item.xpath('link').text,
       :datetime => item.xpath('pubDate').text.to_datetime,
       :description => item.xpath('description').text,
       :content => item.xpath('content:encoded', "content" => "http://purl.org/rss/1.0/modules/content/").text,
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

  def update_frequency_in_seconds(frequency_units, frequency_in_units)
    unit_in_seconds = { 'hourly' => 3600, 'daily' => 86400, 'weekly' => 604800,
      'monthly' => 2419200, 'yearly' => 31449600}
    unit_in_seconds[frequency_units] / frequency_in_units
  end

end
