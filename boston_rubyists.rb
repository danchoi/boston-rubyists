require 'sinatra'
require 'sequel'
require 'ostruct'
DB = Sequel.connect "postgres:///bostonruby"

class BostonRubyists < Sinatra::Base

  get('/') {
    @updates = DB[:updates].order(:date.desc).limit(400).map {|r| OpenStruct.new(r)}
    erb :index 
  }

  run! if app_file == $0
end
