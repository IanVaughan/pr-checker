require "./server"
require 'sidekiq/web'

run Rack::URLMap.new('/' => BaseServer, '/sidekiq' => Sidekiq::Web)
