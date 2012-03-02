
# This script searches GitHub for all programmers in New England and prints
# their GitHub usersnames out, one per line.


require 'nokogiri'
require 'csv'
require 'sequel'
require 'yaml'

CONFIG = YAML::load_file("config.yml")
DB = Sequel.connect ENV['DATABASE_URL'] || CONFIG['database']

def run loc
  url =  "https://github.com/search?type=Users&language=#{CONFIG['language']}&q=location:#{loc.gsub("+", "%2B")}"
  puts url
  fetch_parse url
end

def fetch_parse url
  html = `curl -s '#{url}'`
  parse html
end

def parse html
  doc = Nokogiri::HTML html
  doc.search("h2.title").each {|h2|
    name = h2.at('a').inner_text.strip
    details = h2.xpath("./following-sibling::div[1]")
    followers = details.inner_text[/(\d+) followers/, 1].strip
    repos = details.inner_text[/(\d+) repos/, 1].strip
    location = details.inner_text[/located in (.+)$/, 1].strip
    params = {name:name,
        followers:followers.to_i,
        repos:repos.to_i,
        location:location,
        updated:Time.now}

    if DB[:hackers].first name:name
      puts "Updating #{name}"
      DB[:hackers].filter(name:name).update(params)
    else
      puts "Inserting #{name}"
      DB[:hackers].insert(params)
    end
  }
  if (span = doc.at(".pagination .current")) && (nextpage = span.xpath("./following-sibling::*")[0])
    fetch_parse nextpage[:href]
  end
end

# locations = CONFIG['locations']
# locations.each {|loc|
#   puts '-' * 20
#   puts "Searching #{loc}"
#   run loc
# }

def find_or_create(name)
  if !DB[:hackers].first(name: name)
    puts "Inserting #{name}"
    DB[:hackers].insert(name: name)
  # else
  #   DB[:hackers].filter(name: name).update(location: 'NC')
  end
end

hackers = CONFIG['hackers']
hackers.each {|r| find_or_create(r) }
