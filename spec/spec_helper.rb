require 'rspec'
require "pry"

# require File.expand_path("../../environment", __FILE__)

# require 'rubygems'
# require 'bundler/setup'
# require "pony"
# require 'webmock/rspec'

# ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.order = 'random'

  # config.before(:each) do
  #   allow(Pony).to receive(:deliver)
  # end
end
