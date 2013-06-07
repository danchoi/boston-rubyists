
# aggregates boston ruby blogs
#

require 'nokogiri'
require 'feed_yamlizer'
require 'yaml'
require 'sequel'

if ENV["RUNNING_ON"] == "heroku"
  # feed_yamlizer calls the tidy binary directly; heroku needs special support.
  ENV["PATH"] = "/app/lib/tidy/bin/:#{ENV['PATH']}"
  ENV["LD_LIBRARY_PATH"] ||="/usr/lib"
  ENV["LD_LIBRARY_PATH"] +=":/app/lib/tidy/lib"
end


CONFIG = YAML::load_file("config.yml")
DB = Sequel.connect ENV['DATABASE_URL'] || CONFIG['database']
opml_url = CONFIG['opml']

opml = `curl -Ls "#{opml_url}"`
feeds = Nokogiri::XML(opml).search('outline').map {|o|
  t = o[:text]
  if DB[:blogs].first title: t
    # nothing
  else
    DB[:blogs].insert title:t, feed_url:o[:xmlUrl], html_url:o[:htmlUrl]
  end
  o[:xmlUrl]
}
feeds.each {|f|

  feedyml = `curl -Ls '#{f}' | feed2yaml`
  x = YAML::load feedyml

  begin
    items = x[:items]
  rescue
    puts "*** Skipping over what is probably a bad feed: #{f}"
    next
  end

  items.each { |i|
    html = i[:content][:html]
    content = if html
      n = Nokogiri::HTML(html).at('p')
      if n
        words = n.inner_text[0,355].split(/\s/)
        words[0..-2].join(' ') + '...'
      end
    end

    if content
      content.force_encoding("UTF-8")
    end
    e = {
      blog: x[:meta][:title],
      feed_url: f,
      href: i[:link],
      title: i[:title],
      author: i[:author],
      date: i[:pub_date],
      summary: content
    }
    if DB[:blog_posts].first href: e[:href]
      $stderr.print '.'
    else
      puts "Inserting #{e[:blog]} => #{e[:title]}"
      DB[:blog_posts].insert e
    end
  }
}
