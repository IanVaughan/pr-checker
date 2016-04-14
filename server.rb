require 'sinatra'
require "pry"

require "./lib/config"
require "./lib/remote"
require "./lib/parser"

config = Config.new
client = Remote.setup(config.access_token)
parser = Parser.new(config, client)

set :bind, '0.0.0.0' # Required for Docker

get "/ping" do
  "pong"
end

post '/payload' do
  parser.parse(request)
end
