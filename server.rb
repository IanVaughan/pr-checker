require './environment'
require "sinatra/base"

class BaseServer < Sinatra::Base
  set :bind, '0.0.0.0' # Required for Docker

  post '/payload' do
    status 200
    data = JSON.parse(request.body.read, symbolize_names: true)
    body GitHub::Handler.new.call(data)
  end
end
