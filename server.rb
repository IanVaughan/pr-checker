require 'sinatra'

require "./lib/config"
require "./lib/remote"
require "./lib/parser"

config = PrChecker::Config.new
client = PrChecker::Remote.setup(config.access_token)
parser = PrChecker::Parser.new(config, client)

set :bind, '0.0.0.0' # Required for Docker

get "/ping" do
  "pong"
end

post '/payload' do
  parser.parse(request)
end
