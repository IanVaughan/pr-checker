require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::Pipeline do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project_id, pipeline_id) }

  let(:project) { load_fixture_yml('gitlab/formatted/project2.yml') }
  let(:project_id) { project["id"] }

  let(:pipeline) { load_fixture_yml('gitlab/formatted/pipeline.yml') }
  let(:pipeline_detail) { load_fixture_yml('gitlab/formatted/pipeline_detail.yml') }
  let(:pipeline_id) { pipeline["id"] }

  let!(:saved_protect) { Project.create!(project) }
  let!(:saved_pipeline) { saved_protect.pipelines.create!(id: pipeline_id, info: pipeline) }

  describe '#perform', sidekiq: :fake do
    it "saves" do
      expect_any_instance_of(Gitlab::Pipeline).to receive(:call).and_return(pipeline_detail)

      perform

      expect(Workers::Jobs.jobs.size).to eq(1)
      expect(Workers::Jobs.jobs.first["args"]).to eq [project_id, pipeline_id]

      # expect(saved_protect.reload.pipelines.last.info).to eq merge_request
    end
  end
end
