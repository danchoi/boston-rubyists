require 'sequel'
require 'yaml'
require 'nokogiri'

config = YAML::load_file 'config.yml'

DB = Sequel.connect config['database']

url = config['twitters']
html = `curl -Ls #{url}`

twitter_fields = %w( id created_at user_screen_name user_description user_location user_followers_count text retweet_count 
  user_profile_image_url)
Nokogiri::HTML(html).search('a').select {|a| a[:href] =~ /twitter.com/}.each {|x|
  screen_name = x[:href][/\/(\w+)\/?$/,1]
  return unless screen_name
  url = "http://api.twitter.com/1/statuses/user_timeline.xml?screen_name=#{screen_name}&include_rts=true&count=20"
  sleep 0.5
  xml = `curl -Ls '#{url}'`
  doc = Nokogiri::XML(xml)
  doc.search("status").each {|status|
    params = twitter_fields.reduce({}) {|m, field|
      path = field.sub("user_", "user/")
      if path == 'created_at'
        date = Time.parse(status.at(path).inner_text).localtime
        m[:created_at] = date
      else
        m[field.to_sym] = status.at(path).inner_text
      end
      m
    }
    
    if DB[:tweets].first(id:params[:id])
      $stderr.print '.'
    else
      puts "Inserting tweet: #{params[:user_screen_name]} => #{params[:text]}"
      DB[:tweets].insert params
    end
  }

}
