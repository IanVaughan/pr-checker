require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::MergeRequest do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project.id, merge_request.id) }

  let!(:project) { create_project }
  let!(:merge_request) { create_merge_request(project, info: {}) }

  describe '#perform', sidekiq: :fake do
    it "saves" do
      expect_any_instance_of(Gitlab::MergeRequest).to receive(:call).with(project, merge_request.iid).and_return(merge_request_full_fixture)

      perform

      expect(merge_request.reload.info).to eq(merge_request_full_fixture)
    end
  end
end
