require 'rubygems'
require 'rspec'
require "pry"
require 'rack/test'

# require 'gitlab/'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../../environment', __FILE__)

def load_fixture(name)
  path = "#{Dir.pwd}/spec/support/fixtures/#{name}.json"
  file = File.read(path)
  JSON.parse(file, symbolize_names: true)
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.raise_errors_for_deprecations!

  config.expose_dsl_globally = false
end

# RSpec.configure do |config|
#   config.before(:each) do
#     Sidekiq::Worker.clear_all
#   end
# end
