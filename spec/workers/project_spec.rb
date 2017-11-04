require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::Project do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project.id) }
  let!(:project) { create_project }

  describe '#perform', sidekiq: :fake do
    it 'enqueues MergeRequests and Pipelines sidekiq workers' do
      expect_any_instance_of(Gitlab::Project).to receive(:call).and_return(project_full_fixture)

      perform

      expect(Workers::MergeRequests.jobs.size).to eq(1)
      expect(Workers::MergeRequests.jobs.first["args"]).to eq [project.id]

      expect(Workers::Pipelines.jobs.size).to eq(1)
      expect(Workers::Pipelines.jobs.first["args"]).to eq [project.id]

      expect(Workers::Branches.jobs.size).to eq(1)
      expect(Workers::Branches.jobs.first["args"]).to eq [project.id]

      expect(project.reload.info).to eq project_full_fixture
    end
  end
end
