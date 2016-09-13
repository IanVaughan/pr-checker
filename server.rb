require 'sinatra'
require './environment'

config = PrChecker::Config.new
client = PrChecker::Remote.setup(config.access_token)
parser = PrChecker::Parser.new(config, client)

set :bind, '0.0.0.0' # Required for Docker

get '/ping' do
  'pong'
end

post '/payload' do
  status 200
  data = JSON.parse(request.body.read, symbolize_names: true)
  body parser.parse(data)
end
