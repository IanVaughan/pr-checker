require 'rubygems'
require 'rspec'
require "pry"
require 'rack/test'
require 'database_cleaner'

require "./spec/support/factories"

ENV['RACK_ENV'] = 'test'

require File.expand_path('../../environment', __FILE__)

def load_fixture(name)
  path = "#{Dir.pwd}/spec/support/fixtures/#{name}.json"
  file = File.read(path)
  JSON.parse(file, symbolize_names: true)
end

# File.write('pipelines.yml', pipelines.to_yaml)

def load_fixture_yml(name)
  path = "#{Dir.pwd}/spec/support/fixtures/#{name}"
  YAML.load_file(path).with_indifferent_access
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.raise_errors_for_deprecations!

  config.expose_dsl_globally = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

RSpec.configure do |config|
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end
