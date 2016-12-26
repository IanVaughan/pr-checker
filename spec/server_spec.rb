require 'spec_helper'
require 'rack/test'
require File.expand_path("../../server", __FILE__)

RSpec.describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'pings' do
    get '/ping'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('pong')
  end

  it 'accepts a JSON payload and passes it as a hash to parser' do
    payload = { foo: 'bar' }
    expect_any_instance_of(Parser).to receive(:parse).with(payload).and_return('parser response')

    post '/payload', payload.to_json

    expect(last_response).to be_ok
    expect(last_response.body).to eq('parser response')
  end
end
