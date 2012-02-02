require 'sinatra'
require 'sequel'
require 'json'
require 'logger'
DB = Sequel.connect "postgres:///bostonruby", logger: Logger.new(STDERR)

class BostonRubyists < Sinatra::Base

  get('/') {
    ds = DB[:updates].order(:date.desc).limit(400).
      filter("date < now() - interval '5 hour'")
    @updates = ds.to_a[0,3]
    erb :index 
  }

  get('/updates') {
    ds = DB[:updates].order(:date.desc).limit(400)
    @updates = ds.filter("date > ?", params[:from_time]).to_a
    @updates.to_json
  }

  run! if app_file == $0
end
