require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::Job do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project_id, pipeline_id, job_id) }

  let(:project) { load_fixture_yml('gitlab/formatted/project2.yml') }
  let(:project_id) { project["id"] }

  let(:pipeline_detail) { load_fixture_yml('gitlab/formatted/pipeline_detail.yml') }
  let(:pipeline_id) { pipeline_detail["id"] }

  let(:job) { load_fixture_yml('gitlab/formatted/job.yml') }
  let(:job_id) { job["id"] }

  let!(:saved_protect) { Project.create!(project) }
  let!(:saved_pipeline) { saved_protect.pipelines.create!(id: pipeline_id, info: pipeline_detail) }
  let!(:saved_job) { saved_pipeline.jobs.create!(id: job_id, info: job) }

  describe '#perform', sidekiq: :fake do
    it "works" do
      perform
    end
  end
end
