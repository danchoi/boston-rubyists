$:.unshift 'lib'
require './webapp.rb'
require 'rack-rewrite

use Rack::Rewrite do
  rewrite '/wiki/John_Trupiano', '/john'
  r301 '/wiki/Yair_Flicker', '/yair'
  r302 '/wiki/Greg_Jastrab', '/greg'
  r301 %r{/(\w+)}, '/rubyists/$1'
end

run BostonRubyists
