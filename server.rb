require 'sinatra'
require './environment'
# require 'sinatra/base'
#
# require "./lib/config"
# require "./lib/remote"
# require "./lib/parser"

# set :bind, '0.0.0.0' # Required for Docker
module PrChecker
  class Server < Sinatra::Base
    set :bind, '0.0.0.0' # Required for Docker

    config = Config.new
    client = Remote.setup(config.access_token)
    parser = Parser.new(config, client)

    get "/ping" do
      "pong"
    end
  end
end
