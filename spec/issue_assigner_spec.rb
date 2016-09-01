require 'spec_helper'
require 'json'

RSpec.describe IssueAssigner do
  let(:instance) { described_class.new(client, config) }
  let(:client) { double PrChecker::Remote }
  let(:config) { double 'config', assignees_filenames: assignees_filenames }

  let(:org_repo) { 'OrgName/RepoName' }
  let(:issue_number) { 42 }

  context 'finds no file' do
    let(:assignees_filenames) { ['not-existent-file'] }

    it 'does not update assignees' do
      expect(client).to receive(:get).with(
        "/repos/#{org_repo}/contents/#{assignees_filenames.last}"
      ).and_raise(Octokit::NotFound)

      expect(client).to_not receive(:post)

      returned_result = instance.call(org_repo, issue_number)
      expect(returned_result).to eq "Could not find files:#{assignees_filenames}"
    end
  end

  context 'finds one of the assignee files' do
    let(:get_contents) { load_fixture('get_contents') }
    let(:assignees_filenames) { ['pull_request_assignees', 'not-existent-file'] }
    let(:assignees) { ["OnOneLine", "TwoNames", "OnSameLine"] }

    it 'assigns the names from the file to the pull request' do
      expect(client).to receive(:get).with(
        "/repos/#{org_repo}/contents/#{assignees_filenames.first}"
      ).and_return(get_contents)

      expect(client).to receive(:get).with(
        "/repos/#{org_repo}/contents/#{assignees_filenames.last}"
      ).and_raise(Octokit::NotFound)

      expect(client).to receive(:post).with(
        "/repos/#{org_repo}/issues/#{issue_number}/assignees",
        { assignees: assignees }
      )

      returned_result = instance.call(org_repo, issue_number)
      expect(returned_result).to eq "Assigned:#{assignees}, from files:#{assignees_filenames}"
    end
  end

  context 'finds two assignee files' do
    let(:get_contents) { load_fixture('get_contents') }
    let(:get_contents2) { get_contents.merge content: Base64.encode64("OnOneLine AnewName") }
    let(:assignees_filenames) { ['pull_request_assignees', 'another_file'] }
    let(:assignees) { ["OnOneLine", "TwoNames", "OnSameLine", 'AnewName'] }

    it 'assigns unique names from both files' do
      expect(client).to receive(:get).with(
        "/repos/#{org_repo}/contents/#{assignees_filenames.first}"
      ).and_return(get_contents)

      expect(client).to receive(:get).with(
        "/repos/#{org_repo}/contents/#{assignees_filenames.last}"
      ).and_return(get_contents2)

      expect(client).to receive(:post).with(
        "/repos/#{org_repo}/issues/#{issue_number}/assignees",
        { assignees: assignees }
      )

      returned_result = instance.call(org_repo, issue_number)
      expect(returned_result).to eq "Assigned:#{assignees}, from files:#{assignees_filenames}"
    end
  end
end
