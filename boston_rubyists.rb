require 'sinatra'
require 'sequel'
require 'json'
require 'logger'
DB = Sequel.connect "postgres:///bostonruby", logger: Logger.new(STDERR)

class BostonRubyists < Sinatra::Base

  get('/') {
    ds = DB[:updates].order(:date.desc).limit(40)
    @updates = ds.to_a.map {|x| 
      x[:content] = x[:content].gsub(/^/, ' ' * 6).gsub(/href="\//, 'href="https://github.com/') 
      x
    }
    erb :index 
  }

  get('/updates') {
    ds = DB[:updates].order(:date.desc).limit(100)
    @updates = ds.filter("date > ?", params[:from_time]).to_a
    @updates.to_json
  }

  run! if app_file == $0
end
