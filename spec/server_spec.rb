require "spec_helper"
require 'rack/test'
# require './server'
require File.expand_path("../../server", __FILE__)

RSpec.describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "pings" do
    get '/ping'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('pong')
  end

  it "accepts payload" do
    ENV["PR_CHECKER_ACCESS_TOKEN"] = "d"
    post '/payload', {}
    expect(last_response).to be_ok
    expect(last_response.body).to eq('')
  end
end
