require 'nokogiri'
require 'time'

d = Nokogiri::XML.parse STDIN.read
d.search('entry').each {|e|
  item = {
    id: e.at('id').inner_text,
    date: Time.parse(e.at('published').inner_text).strftime("%b %d %I:%M%p"), 
    title: e.at('title').inner_text,
    content: e.at('content').inner_text,
    media: e.xpath('media:thumbnail',{'media'=>"http://search.yahoo.com/mrss/"}).first[:url]
  }
  puts item.inspect
}


