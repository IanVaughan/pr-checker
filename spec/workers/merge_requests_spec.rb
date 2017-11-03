require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::MergeRequests do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project_id) }
  let(:project_id) { project["id"] }
  let(:project) { load_fixture_yml('gitlab/formatted/project2.yml') }
  let(:merge_request) { load_fixture_yml('gitlab/formatted/merge_request.yml') }
  let!(:saved_protect) { Project.create!(project) }

  describe '#perform', sidekiq: :fake do
    it "saves them both" do
      expect_any_instance_of(Gitlab::MergeRequests).to receive(:call).and_return([merge_request])

      # perform
      expect { perform }.to change(Workers::MergeRequest.jobs, :size).from(0).to(1)
      expect(Workers::MergeRequest.jobs.first["args"]).to eq [project_id, merge_request[:id]]

      # expect(saved_protect.reload.merge_requests.last.info).to eq merge_request
    end
  end
end
