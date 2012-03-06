require 'gilt'

AtomFeeds = [
  "https://api.gilt.com/v1/sales/men/active.atom",
#  "https://api.gilt.com/v1/sales/women/active.atom",
]

class Scraper < Struct.new(:feeds)

  def self.perform
    new(AtomFeeds).perform
  end

  def perform
    feeds.each do |feed|
      feed = Nokogiri::HTML(open(feed))

      urls = feed.xpath("//entry/link").map{|link| link.attributes["href"].value }.uniq

      Importer.new(*urls).perform
    end
  end
end
