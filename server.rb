require 'sinatra'
require './environment'

logger = Logger.new(STDOUT)
config = PrChecker::Config.new
client = PrChecker::Remote.setup(config.access_token)
parser = PrChecker::Parser.new(config, client)
# jira_parser = Jira::Parser.new(logger: logger)

set :bind, '0.0.0.0' # Required for Docker

get '/ping' do
  'pong'
end

def parsed_data
  JSON.parse(request.body.read, symbolize_names: true)
end

post '/payload' do
  status 200
  body parser.parse(parsed_data)
end

# post '/payloads/jira' do
#   status 200
#   body jira_parser.parse(parsed_data)
# end
