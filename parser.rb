require 'nokogiri'
require 'time'
require 'sequel'
DB = Sequel.connect File.read('database.conf').strip

d = Nokogiri::XML.parse STDIN.read
d.search('entry').each {|e|
  item = {
    update_id: e.at('id').inner_text,
    author: e.at('name').inner_text,
    date: Time.parse(e.at('published').inner_text), # .strftime("%b %d %I:%M%p"), 
    title: e.at('title').inner_text,
    content: e.at('content').inner_text,
    media: e.xpath('media:thumbnail',{'media'=>"http://search.yahoo.com/mrss/"}).first[:url]
  }
  puts item[:title]
  DB[:updates].insert item
}


