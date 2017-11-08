require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::Pipelines do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project.id) }
  let!(:project) { create_project }

  describe '#perform', sidekiq: :fake do
    context "first call" do
      it "saves" do
        expect_any_instance_of(Gitlab::Pipelines).to receive(:call).and_return([pipeline_basic_fixture])

        perform

        expect(Workers::Pipeline.jobs.size).to eq(1)
        expect(Workers::Pipeline.jobs.first["args"]).to eq [project.id, pipeline_basic_fixture[:id]]

        expect(project.reload.pipelines.last.sha).to eq pipeline_basic_fixture[:sha]
        expect(project.reload.pipelines.last.info).to eq({})
      end
    end

    context "other call with data" do
      let!(:pipeline) { create_pipeline(project, info: {}) }

      it "saves" do
        expect_any_instance_of(Gitlab::Pipelines).to receive(:call).and_return([pipeline_basic_fixture.merge(sha: '123')])

        perform

        expect(Workers::Pipeline.jobs.size).to eq(1)
        expect(Workers::Pipeline.jobs.first["args"]).to eq [project.id, pipeline[:id]]

        expect(project.reload.pipelines.last.sha).to eq '123'
        expect(project.reload.pipelines.last.info).to eq({})
      end
    end

    context "other call with no data" do
      let!(:pipeline) { create_pipeline(project, info: {}) }

      it "saves" do
        expect_any_instance_of(Gitlab::Pipelines).to receive(:call).and_return([])

        perform

        expect(Workers::Pipelines.jobs.size).to eq(0)
        expect(Workers::Pipeline.jobs.size).to eq(0)

        # expect(saved_protect.reload.merge_requests.last.info).to eq merge_request
      end
    end
  end
end
