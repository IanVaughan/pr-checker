require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::Pipelines do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project_id, page: page) }
  let(:project_id) { project["id"] }

  let(:project) { load_fixture_yml('gitlab/formatted/project2.yml') }
  let!(:saved_protect) { Project.create!(project) }

  let(:pipeline) { load_fixture_yml('gitlab/formatted/pipeline.yml') }

  describe '#perform', sidekiq: :fake do
    let(:page) { nil }

    context "first call" do
      it "saves" do
        expect_any_instance_of(Gitlab::Pipelines).to receive(:call).and_return([pipeline])

        perform

        expect(Workers::Pipelines.jobs.size).to eq(1)
        expect(Workers::Pipelines.jobs.first["args"]).to eq [project_id, 2]
        expect(Workers::Pipeline.jobs.size).to eq(1)
        expect(Workers::Pipeline.jobs.first["args"]).to eq [project_id, pipeline[:id]]

        # expect(saved_protect.reload.pipelines.last.info).to eq merge_request
      end
    end
  end

  context "other call with data" do
    let(:page) { 2 }

    it "saves" do
      expect_any_instance_of(Gitlab::Pipelines).to receive(:call).and_return([pipeline])

      perform

      expect(Workers::Pipelines.jobs.size).to eq(1)
      expect(Workers::Pipelines.jobs.first["args"]).to eq [project_id, 3]
      expect(Workers::Pipeline.jobs.size).to eq(1)
      expect(Workers::Pipeline.jobs.first["args"]).to eq [project_id, pipeline[:id]]

      # expect(saved_protect.reload.merge_requests.last.info).to eq merge_request
    end
  end

  context "other call with no data" do
    let(:page) { 3 }

    it "saves" do
      expect_any_instance_of(Gitlab::Pipelines).to receive(:call).and_return([])

      perform

      expect(Workers::Pipelines.jobs.size).to eq(0)
      expect(Workers::Pipeline.jobs.size).to eq(0)

      # expect(saved_protect.reload.merge_requests.last.info).to eq merge_request
    end
  end
end
