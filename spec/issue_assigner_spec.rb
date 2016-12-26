require 'spec_helper'
require 'json'

RSpec.describe IssueAssigner do
  let(:instance) { described_class.new(client) }
  let(:client) { double Client }
  let(:assignees) do
    [ 'Paul', 'Foo' ]
  end

  let(:org_repo) { 'OrgName/RepoName' }
  let(:issue_number) { 42 }

  let(:returned_result) { instance.call(org_repo, issue_number, assignees) }

  it 'assigns the names from the file to the pull request' do
    expect(client).to receive(:post).with(
      "/repos/#{org_repo}/issues/#{issue_number}/assignees",
      { assignees: assignees }
    )

    expect(returned_result).to \
      eq "Assigned:#{assignees}"
  end
end
