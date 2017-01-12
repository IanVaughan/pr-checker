require 'spec_helper'
require 'rack/test'
require File.expand_path("../../server", __FILE__)

RSpec.describe 'Server' do
  include Rack::Test::Methods

  def app
    BaseServer
  end

  let(:pull_request) { load_fixture('pull_request') } # pull_request.json - Github new PR webhook post payload
  it 'accepts a JSON payload and passes it as a hash to the handler' do
    expect_any_instance_of(GitHub::Handler).to(
      receive(:call).with(pull_request).and_return('parser response')
    )

    post '/payload', pull_request.to_json

    expect(last_response).to be_ok
    expect(last_response.body).to eq('parser response')
  end
end
