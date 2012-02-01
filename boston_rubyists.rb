require 'sinatra'
require 'sequel'
require 'json'
DB = Sequel.connect "postgres:///bostonruby"

class BostonRubyists < Sinatra::Base

  get('/') {
    @updates = DB[:updates].order(:date.desc).limit(400).to_a
    erb :index 
  }

  get('/updates') {
    @updates = DB[:updates].order(:date.desc).limit(400).to_a
    @updates.to_json
  }

  run! if app_file == $0
end
