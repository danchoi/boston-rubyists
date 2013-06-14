require 'sequel'
require 'yaml'
require 'twitter'

config = YAML::load_file 'config.yml'

DB = Sequel.connect ENV['DATABASE_URL'] || config['database']

def update_tweet(screen_name)
  user      = Twitter.user(screen_name)
  user_data = {:user_screen_name       => user.screen_name,
               :user_description       => user.description,
               :user_location          => user.location,
               :user_followers_count   => user.followers_count,
               :user_profile_image_url => user.profile_image_url}

  time_line = Twitter.user_timeline(screen_name)
  time_line.each do |status|
    params = {:id            => status.id,
              :created_at    => status.created_at,
              :text          => status.text,
              :retweet_count => status.retweet_count}.merge(user_data)

    if DB[:tweets].first(id:params[:id])
      $stderr.print '.'
    else
      puts "Inserting tweet: #{params[:user_screen_name]} => #{params[:text]}"
      DB[:tweets].insert params
    end
  end
end

tweeters = config['tweeters']
tweeters.each {|r| update_tweet r }
