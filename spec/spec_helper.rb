require 'rubygems'
require 'rspec'
require "pry"
require 'rack/test'

ENV['RACK_ENV'] = 'test'

# require File.expand_path('../../environment', __FILE__)
require File.expand_path('../../lib/config_reader', __FILE__)
require File.expand_path('../../lib/config', __FILE__)
require File.expand_path('../../lib/issue_assigner', __FILE__)
require File.expand_path('../../lib/parser', __FILE__)
require File.expand_path('../../lib/remote', __FILE__)

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
