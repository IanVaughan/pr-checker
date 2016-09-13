require 'spec_helper'
require 'webmock/rspec'
require File.expand_path("../../../server", __FILE__)

RSpec.describe 'Post request received about a pull request' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:client) { double PrChecker::Remote }

  context 'a new PR is raised' do
    let(:pull_request) { load_fixture('pull_request') } # pull_request.json - Github new PR webhook post payload

    it 'posts an initial fail status' do
      stub_request(:post, "https://api.github.com/repos/QuiqUpLTD/QuiqupAPI/statuses/8aaecf682331bd819995efecc3996aab3d84ecc9").
        with(:body => "{\"context\":\"2+1s\",\"description\":\"Require at least two people to add a +1\",\"state\":\"failure\"}").
        to_return(:status => 200, :body => "", :headers => {})

      post '/payload', pull_request.to_json
      expect(last_response).to be_ok
    end
  end

  context 'a new comment is added to a PR' do
    let(:api_path) { 'https://api.github.com/repos/QuiqUpLTD/QuiqupAPI' }
    let(:request) { load_fixture('issue_comment') } 
    let(:issue_comments) { load_fixture('issue_comments') }
    let(:commits) { load_fixture('commits') }

    it 'posts' do
      # gets all pull request comments
      stub_request(:get, "#{api_path}/issues/4572/comments").to_return(status: 200, body: issue_comments)
      # remove assignee that reviewed the PR
      stub_request(:delete, "#{api_path}/issues/4572/assignees").with(body: "{\"assignees\":\"IanVaughan\"}")
      # get the last commit sha to update status
      stub_request(:get, "#{api_path}/pulls/4572/commits").to_return(status: 200, body: commits)
      # sets the status on the git sha
      stub_request(:post, "#{api_path}/statuses/40f69bd8d3e0ab242bf57c3b8c3c17b967cf5bf9")

      post '/payload', request.to_json
      expect(last_response).to be_ok
    end
  end
end