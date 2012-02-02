
# aggregates boston ruby blogs
#

require 'nokogiri'
require 'feed_yamlizer'
require 'sequel'
DB = Sequel.connect File.read('database.conf').strip

opml = `curl -Ls "http://www.blogbridge.com/rl/291/Boston+Ruby.opml"`
feeds = Nokogiri::XML(opml).search('outline').map {|o| o[:xmlUrl]}
feeds.each {|f|
  feedyml = `curl -Ls '#{f}' | feed2yaml`
  x = YAML::load feedyml
  x[:items].each { |i| 
    e = { 
      blog: x[:meta][:title],
      href: i[:link],
      title: i[:title],
      author: i[:author],
      date: i[:pub_date],
      summary: i[:content][:html]
    }
    if DB[:blog_posts].first href: e[:href]
      # skip
    else
      puts "Inserting #{e[:blog]} => #{e[:title]}"
      DB[:blog_posts].insert e
    end
  }    
}
