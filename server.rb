require './environment'
require "sinatra/base"

class BaseServer < Sinatra::Application
  LOGGER = Logger.new("log/server_#{ENV['RACK_ENV']}.log")

  def response_json
    request.body.rewind
    JSON.parse(request.body.read, symbolize_names: true)
  end

  get '/ping' do
    LOGGER.info "ping"
    'pong'
  end

  post '/github/payload' do
    status 200
    body GitHub::Handler.new.call(response_json)
  end

  post '/gitlab/hooks/system' do
    status 200
    data = response_json
    LOGGER.info "GitLab system hook:#{data}"
    body Gitlab::Handler.new.call(data)
  end

  post '/gitlab/hooks/project' do
    status 200
    data = response_json
    LOGGER.info "GitLab project hook:#{data}"
    body Gitlab::Handler.new.call(data)
  end

  post '/gitlab/add_hook' do
    status 200
    body ""
  end

  post '/gitlab/refresh' do
    status 200
    body Workers::Projects.perform_async
  end
end
