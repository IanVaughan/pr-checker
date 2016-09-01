require 'rspec'
require "pry"

# require File.expand_path("../../environment", __FILE__)

# require 'rubygems'
# require 'bundler/setup'
# require 'webmock/rspec'
require 'rubygems'
require 'rack/test'
require 'pry'
# require 'webmock/rspec'
#
ENV['RACK_ENV'] = 'test'


# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
# require File.expand_path('../../config/environment', __FILE__)
require File.expand_path('../../lib/config', __FILE__)
require File.expand_path('../../lib/parser', __FILE__)
require File.expand_path('../../lib/remote', __FILE__)

# ActiveRecord::Base.logger = nil

def load_fixture(name)
  path = "#{Dir.pwd}/spec/support/fixtures/#{name}.json"
  file = File.read(path)
  JSON.parse(file, symbolize_names: true)
end

RSpec.configure do |config|
  config.order = 'random'

  config.mock_with :rspec
  config.expect_with :rspec
  config.raise_errors_for_deprecations!
  # config.rack_app = FraudService::App.instance

  # config.include Testing::Methods

  config.expose_dsl_globally = false
end
