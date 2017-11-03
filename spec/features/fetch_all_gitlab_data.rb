require 'spec_helper'
require 'webmock/rspec'
# require File.expand_path("../../../server", __FILE__)
require 'sidekiq/testing'

RSpec.describe 'Fetch all data', sidekiq: :fake do
  # Sidekiq::Testing.fake!
  # include Rack::Test::Methods

  it "do" do
    expect { Workers::Projects.perform_async }.to change(Workers::Projects.jobs, :size).by(1)

    response = [
    {
        "id": 294,
        "description": "",
        "default_branch": "master",
        "tag_list": [],
        "ssh_url_to_repo": "git@gitlab.quiqup.com:danhawkins/testing-deploy.git",
        "http_url_to_repo": "https://gitlab.quiqup.com/danhawkins/testing-deploy.git",
        "web_url": "https://gitlab.quiqup.com/danhawkins/testing-deploy",
        "name": "testing-deploy",
        "name_with_namespace": "Danny Hawkins / testing-deploy",
        "path": "testing-dseploy",
        "path_with_namespace": "danhawkins/testing-deploy",
        "star_count": 0,
        "forks_count": 0,
        "created_at": "2017-10-18T12:08:38.570Z",
        "last_activity_at": "2017-10-18T12:08:38.570Z"
    }]

    url = "https://gitlab.quiqup.com/api/v4/projects?per_page=2000&simple=true"
    stub_request(:get, url).to_return(status: 200, body: response, headers: {})
    #  with headers {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Private-Token'=>'gF6yksySZWWgrmhdnp43'}

    Workers::Projects.drain
  end

  # context 'a new PR is raised' do
    # let(:pull_request) { load_fixture('pull_request') } # pull_request.json - Github new PR webhook post payload

    # it 'posts an initial fail status' do
    #   stub_request(:post, "https://api.github.com/repos/QuiqUpLTD/QuiqupAPI/issues/4577/assignees").
    #     with(:body => "{\"assignees\":null}").
    #     to_return(:status => 200, :body => "", :headers => {})
    #
    #   stub_request(:post, "https://api.github.com/repos/QuiqUpLTD/QuiqupAPI/statuses/8aaecf682331bd819995efecc3996aab3d84ecc9").
    #     with(:body => "{\"context\":\"No context configured\",\"description\":\"No description configured\",\"state\":\"pending\"}").
    #     to_return(:status => 200, :body => "", :headers => {})
    #
    #   stub_request(:get, "https://api.github.com/repos/QuiqUpLTD/QuiqupAPI/contents/.pr-checker.yml").
    #     to_return(status: 200, body: { content: 'cmV2aWV3ZXJzOgogIC0gUGF1bAogIC0gU2ltb24K\n' }.to_json )
    #
    #   post '/payload', pull_request.to_json
    #   expect(last_response).to be_ok
    # end
  # end
  #
  # context 'a new comment is added to a PR' do
  #   let(:api_path) { 'https://api.github.com/repos/QuiqUpLTD/QuiqupAPI' }
  #   let(:request) { load_fixture('issue_comment') }
  #   let(:issue_comments) { load_fixture('issue_comments') }
  #   let(:commits) { load_fixture('commits') }
  #
  #   it 'posts' do
  #     # gets all pull request comments
  #     stub_request(:get, "#{api_path}/issues/4572/comments").to_return(status: 200, body: issue_comments)
  #     # remove assignee that reviewed the PR
  #     stub_request(:delete, "#{api_path}/issues/4572/assignees").with(body: "{\"assignees\":\"IanVaughan\"}")
  #     # get the last commit sha to update status
  #     stub_request(:get, "#{api_path}/pulls/4572/commits").to_return(status: 200, body: commits)
  #     # sets the status on the git sha
  #     stub_request(:post, "#{api_path}/statuses/40f69bd8d3e0ab242bf57c3b8c3c17b967cf5bf9")
  #
  #     post '/payload', request.to_json
  #     expect(last_response).to be_ok
  #   end
  # end
end
