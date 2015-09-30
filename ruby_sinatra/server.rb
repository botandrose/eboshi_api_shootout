require 'bundler/setup'
require 'sinatra'

set :port, 6969

get '/api/test' do
  'Hello world'
end
