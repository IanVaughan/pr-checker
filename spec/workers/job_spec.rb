require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::Job do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project.id, pipeline.id, job.id) }

  let!(:project) { create_project }
  let!(:pipeline) { create_pipeline(project) }
  let!(:job) { create_job(pipeline) }

  describe '#perform', sidekiq: :fake do
    it "works" do
      perform
    end
  end
end
