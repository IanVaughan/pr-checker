require "./server"
require 'sidekiq/web'
# require './config/initializers/sidekiq'

run Rack::URLMap.new('/' => BaseServer, '/sidekiq' => Sidekiq::Web)
