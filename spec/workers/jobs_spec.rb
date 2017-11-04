require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::Jobs do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project.id, pipeline.id) }

  let!(:project) { create_project }
  let!(:pipeline) { create_pipeline(project) }

  describe '#perform', sidekiq: :fake do
    context "with new data" do
      it "saves" do
        expect_any_instance_of(Gitlab::Jobs).to receive(:call).and_return([job_fixture])

        perform

        expect(Workers::Job.jobs.size).to eq(1)
        expect(Workers::Job.jobs.first["args"]).to eq [project.id, pipeline.id, job_fixture[:id]]

        expect(Workers::JobTrace.jobs.size).to eq(1)
        expect(Workers::JobTrace.jobs.first["args"]).to eq [project.id, job_fixture[:id]]

        expect(project.reload.pipelines.last.jobs.last.id).to eq job_fixture[:id]
        expect(project.reload.pipelines.last.jobs.last.status).to eq "success"
      end
    end

    context "with existing changed data" do
      let!(:job) { create_job(pipeline) }

      it "saves" do
        expect_any_instance_of(Gitlab::Jobs).to receive(:call).and_return([job_fixture.merge(status: "failed")])

        perform

        expect(Workers::Job.jobs.size).to eq(1)
        expect(Workers::Job.jobs.first["args"]).to eq [project.id, pipeline.id, job_fixture[:id]]

        expect(Workers::JobTrace.jobs.size).to eq(1)
        expect(Workers::JobTrace.jobs.first["args"]).to eq [project.id, job.id]

        expect(job.reload.status).to eq "failed"
      end
    end
  end
end
