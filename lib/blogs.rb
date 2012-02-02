
# aggregates boston ruby blogs
#

require 'nokogiri'
require 'feed_yamlizer'
require 'yaml'
require 'sequel'

CONFIG = YAML::load_file("config.yml")
DB = Sequel.connect CONFIG['database']
opml_url = CONFIG['opml']

opml = `curl -Ls "#{opml_url}"`
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
      $stderr.print '.'
    else
      puts "Inserting #{e[:blog]} => #{e[:title]}"
      DB[:blog_posts].insert e
    end
  }    
}
