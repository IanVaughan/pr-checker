require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::MergeRequests do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project.id) }
  let!(:project) { create_project }

  describe '#perform', sidekiq: :fake do
    it "saves" do
      expect_any_instance_of(Gitlab::MergeRequests).to receive(:call).and_return([merge_request_basic_fixture])

      expect { perform }.to change(Workers::MergeRequest.jobs, :size).from(0).to(1)
      expect(Workers::MergeRequest.jobs.first["args"]).to eq [project.id, merge_request_basic_fixture[:id]]

      expect(project.reload.merge_requests.last.info).to eq({})
    end

    context "with existing data" do
      let!(:merge_request) { create_merge_request(project, info: {}) }
      let(:results) { [merge_request_basic_fixture.merge(title: "foo")] }

      it "saves" do
        expect_any_instance_of(Gitlab::MergeRequests).to receive(:call).and_return(results)

        expect { perform }.to change(Workers::MergeRequest.jobs, :size).from(0).to(1)
        expect(Workers::MergeRequest.jobs.first["args"]).to eq [project.id, merge_request_basic_fixture[:id]]

        expect(merge_request.reload.title).to eq "foo"
        expect(merge_request.info).to eq({})
      end
    end
  end
end
