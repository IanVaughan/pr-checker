require 'sinatra'
require './environment'

set :bind, '0.0.0.0' # Required for Docker

get '/ping' do
  'pong'
end

post '/payload' do
  status 200
  data = JSON.parse(request.body.read, symbolize_names: true)
  body GitHub::Handler.new.call(data)
end
