require 'nokogiri'
require 'time'
require 'sequel'
require 'open-uri'
require 'yaml'
require 'curb'

DB = Sequel.connect File.read('database.conf').strip

def update_atom atom_xml
  d = Nokogiri::XML.parse atom_xml
  d.search('entry').map {|e|
    date = Time.parse(e.at('published').inner_text)

    item = {
      update_id: e.at('id').inner_text,
      author: e.at('name').inner_text,
      date: date.localtime,
      title: e.at('title').inner_text,
      content: e.at('content').inner_text.gsub(/^/, ' ' * 6).gsub(/href="\//, 'href="https://github.com/'),
      media: e.xpath('media:thumbnail',{'media'=>"http://search.yahoo.com/mrss/"}).first[:url]
    }
    if DB[:updates].first update_id:item[:update_id]
      # we can break since the rest of the items will have been seen
      next
    else
      DB[:updates].insert item
      item[:title]
    end
  }.compact
end

def update_list hackers
  m = Curl::Multi.new
  activity = []
  hackers.select {|p| p =~ /\w+/}.map{|p| p.chomp}.each_slice(10).each {|slice|
    slice.each {|programmer|
      puts "Fetching GitHub activity for #{programmer}"
      res = {:body => "", :headers => ""}
      url  = "https://github.com/#{programmer}.atom"
      puts url
      c = Curl::Easy.new(url) { |curl|
        curl.on_body {|data| res[:body] << data; data.size}
        curl.on_header {|data| res[:headers] << data; data.size}
        curl.on_success {|easy| 
          puts "Success for #{programmer}"
          new = update_atom res[:body]
          if new.size > 0 
            puts "#{programmer} -> #{new.size} new items" 
            activity << ({programmer:programmer, items:new.size})
          end
          print "\n"
        }
      }
      m.add c
    }
    m.perform
  }
  puts activity.to_yaml
end
  

hackers = DB[:hackers].all.map {|x| x[:name]}
update_list hackers
