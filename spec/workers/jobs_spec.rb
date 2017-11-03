require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::Jobs do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project_id, pipeline_id) }

  let(:project) { load_fixture_yml('gitlab/formatted/project2.yml') }
  let(:project_id) { project["id"] }

  let(:pipeline_detail) { load_fixture_yml('gitlab/formatted/pipeline_detail.yml') }
  let(:pipeline_id) { pipeline_detail["id"] }

  let!(:saved_protect) { Project.create!(project) }
  let!(:saved_pipeline) { saved_protect.pipelines.create!(id: pipeline_id, info: pipeline_detail) }

  let(:job) { load_fixture_yml('gitlab/formatted/job.yml') }
  let(:job_id) { job["id"] }

  describe '#perform', sidekiq: :fake do
    it "saves" do
      expect_any_instance_of(Gitlab::Jobs).to receive(:call).and_return([job])

      perform

      expect(Workers::Job.jobs.size).to eq(1)
      expect(Workers::Job.jobs.first["args"]).to eq [project_id, pipeline_id, job_id]

      expect(Workers::JobTrace.jobs.size).to eq(1)
      expect(Workers::JobTrace.jobs.first["args"]).to eq [project_id, job_id]

      # expect(saved_protect.reload.pipelines.last.info).to eq merge_request
    end
  end
end
