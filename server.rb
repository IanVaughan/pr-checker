require './environment'
require "sinatra/base"

class BaseServer < Sinatra::Application
  get '/ping' do
    'pong'
  end

  post '/github/payload' do
    status 200
    data = JSON.parse(request.body.read, symbolize_names: true)
    body GitHub::Handler.new.call(data)
  end

  post '/gitlab/refresh' do
    status 200
    body Workers::Projects.perform_async
  end
end
