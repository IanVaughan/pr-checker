require 'spec_helper'
require 'webmock/rspec'
require 'sidekiq/testing'

RSpec.describe 'Fetch all data (refresh/backfill/sync)' do
  Sidekiq::Testing.inline!

  let(:headers) { {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Private-Token'=>'gF6yksySZWWgrmhdnp43'} }

  it "works" do
    stub "https://gitlab.quiqup.com/api/v4/users", [user_fixture]
    stub "https://gitlab.quiqup.com/api/v4/projects?simple=true", [project_basic_fixture]
    stub "https://gitlab.quiqup.com/api/v4/projects/20", project_full_fixture
    stub "https://gitlab.quiqup.com/api/v4/projects/backend%2FCoreAPI/merge_requests?view=simple", [merge_request_basic_fixture]
    stub "https://gitlab.quiqup.com/api/v4/projects/backend%2FCoreAPI/merge_requests/6221", merge_request_basic_fixture
    stub "https://gitlab.quiqup.com/api/v4/projects/20/merge_requests/6221/notes", [note_fixture]
    stub "https://gitlab.quiqup.com/api/v4/projects/backend%2FCoreAPI/pipelines", [pipeline_basic_fixture]
    stub "https://gitlab.quiqup.com/api/v4/projects/backend%2FCoreAPI/pipelines/35279", pipeline_full_fixture
    stub "https://gitlab.quiqup.com/api/v4/projects/backend%2FCoreAPI/pipelines/35279/jobs", [job_fixture]
    stub "https://gitlab.quiqup.com/api/v4/projects/backend%2FCoreAPI/jobs/138476/trace", job_trace_fixture
    stub "https://gitlab.quiqup.com/api/v4/projects/20/repository/branches", [branch_fixture]
    stub "https://gitlab.quiqup.com/api/v4/projects/20/labels", [label_fixture]

    stub("https://gitlab.quiqup.com/api/v4/projects/20/repository/branches/use-name-not-constant", [], method: :delete)

    Workers::Projects.perform_async
  end

  def stub(url, body, method: :get)
    stub_request(method, url).with(headers: headers).to_return(status: 200, body: body.to_json)
  end
end
