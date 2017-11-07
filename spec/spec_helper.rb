require 'rubygems'
require 'rspec'
require "pry"
require 'rack/test'
require 'database_cleaner'

require "./spec/support/factories"

ENV['RACK_ENV'] = 'test'

require File.expand_path('../../environment', __FILE__)

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
  # config.before(:each, sidekiq: true) do
    Sidekiq::Worker.clear_all
  end
end
