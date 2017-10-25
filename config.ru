# require "./server"
# run BaseServer

require 'sidekiq/web'
require './lib/initializers/sidekiq'

run Sidekiq::Web
