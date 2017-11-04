require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::Pipeline do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project.id, pipeline.id) }

  let!(:project) { create_project }
  let!(:pipeline) { create_pipeline(project, info: {}) }

  describe '#perform', sidekiq: :fake do
    it "saves" do
      expect_any_instance_of(Gitlab::Pipeline).to receive(:call).and_return(pipeline_full_fixture)

      perform

      expect(Workers::Jobs.jobs.size).to eq(1)
      expect(Workers::Jobs.jobs.first["args"]).to eq [project.id, pipeline.id]

      expect(pipeline.sha).to eq pipeline_basic_fixture[:sha]
      expect(pipeline.reload.info).to eq(pipeline_full_fixture)
    end
  end
end
