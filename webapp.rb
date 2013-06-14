require 'sinatra'
require 'sequel'
require 'json'
require 'logger'
require 'nokogiri'
require 'yaml'
require 'uri'
require 'timeout'

CONFIG = YAML::load_file 'config.yml'
DB = Sequel.connect ENV['DATABASE_URL'] || CONFIG['database']

class BostonRubyists < Sinatra::Base
  set :static, true
  set :root, File.dirname(__FILE__)

  helpers {
    def prep(p)
      p[:date_string] = p[:date].strftime("%b %d %I:%M %p")
      p[:date] = p[:date].to_s.sub(/\s*[+-]?\d+$/, '')
      if p[:content]
        # strip Github dates because they are redundant
        p[:content] = p[:content].sub(/\w+ \d+, \d{4}/, '')
      end
      p
    end

    def prep_tweet t
      t[:user_screen_name]
      tweet_href = "<a href='http://twitter.com/#{t[:user_screen_name]}/status/#{t[:id]}'>#{t[:created_at].strftime("%b %d %I:%M %p")}</a>"
      t[:user_screen_name].gsub!(/.*/, '<a href="http://twitter.com/\0">\0</a>')
      new = t[:text].gsub(/https?:[\S,\]\)\.\;]+/, '<a href="\0">\0</a>')
      new = new.gsub(/@(\w+)/, '<a href="http://twitter.com/\1">@\1</a>')
      t[:date_string] = tweet_href
      t[:text] = new
      t[:created_at] = t[:created_at].to_s.sub(/\s*[+-]?\d+$/, '')
      t
    end

    def page_title
      CONFIG['page_title']
    end

    def org
      CONFIG['org']
    end

    def poll_interval
      CONFIG['poll_interval'] * 1000
    end

    def config
      CONFIG
    end
  }

  get('/') {
    @hackers = DB[:hackers].order(:followers.desc).to_a
    @updates = DB[:updates].order(:date.desc).limit(110).map {|u| prep u}
    @tweets = DB[:tweets].order(:created_at.desc).limit(200).map {|t| prep_tweet t}
    @blogs = DB[:blogs].all
    @blog_posts = DB[:blog_posts].order(:date.desc).limit(90).map {|p| prep p}
    erb :index
  }

  MAX_ITEMS = 90
  get('/updates') {
    ds = DB[:updates].order(:date.desc).limit(MAX_ITEMS)
    if params[:from_time]
      ds = ds.filter("date > ?", params[:from_time])
    end
    @updates = ds.map {|u| prep u}
    @updates.to_json
  }
  get('/blog_posts') {
    ds = DB[:blog_posts].order(:date.desc).limit(MAX_ITEMS)
    if params[:from_time]
      ds = ds.filter("date > ?", params[:from_time])
    end
    @blog_posts = ds.map {|p| prep p}
    @blog_posts.to_json
  }
  get('/tweets') {
    ds = DB[:tweets].order(:created_at.desc).limit(MAX_ITEMS)
    if params[:from_time]
      ds = ds.filter("created_at > ?", params[:from_time])
    end
    @tweets = params[:raw] ? ds.to_a : ds.map {|p| prep_tweet p} 
    @tweets.to_json
  }

  if CONFIG['weather']
    # The weather config item can point to a Sinatra app that serves up a mini
    # weather report HTML page. This will served as an html fragment.
    get('/weather') {
      begin
        Timeout::timeout(2) {
          `curl -s '#{CONFIG['weather']}'`
        }
      rescue Timeout::Error
        halt 500, "weather service not responding"
      end
    }
  end

  run! if app_file == $0
end
