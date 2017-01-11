require 'spec_helper'

RSpec.describe IssueAssigner do
  let(:instance) { described_class.new(client, config, payload) }
  let(:client) { double Client }
  let(:config) do
    { assignees: [ 'Paul', 'Foo' ] }
  end

  let(:pull_request) { load_fixture('pull_request') }
  let(:payload) do
    GitHub::Parser.new(pull_request).parse
  end

  let(:returned_result) { instance.assign }

  it 'assigns the names from the file to the pull request' do
    expect(client).to receive(:post).with(
      "/repos/#{payload.org_repo}/issues/#{payload.issue_number}/assignees",
      { assignees: config[:assignees] }
    )

    expect(returned_result).to eq "Assigned:#{config[:assignees]}"
  end
end
