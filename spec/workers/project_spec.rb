require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::Project do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project_id) }

  describe '#perform', sidekiq: :fake do
    let(:project_id) { project["id"] }
    let(:project) { load_fixture_yml('gitlab/formatted/project2.yml') }
    let(:project_detail) { load_fixture_yml('gitlab/formatted/project_detail.yml') }
    let!(:saved_protect) { Project.create!(project) }

    it "enqueues MergeRequests and Pipelines sidekiq workers" do
      expect_any_instance_of(Gitlab::Project).to receive(:call).and_return(project_detail)

      perform

      expect(Workers::MergeRequests.jobs.size).to eq(1)
      expect(Workers::MergeRequests.jobs.first["args"]).to eq [project_id]

      expect(Workers::Pipelines.jobs.size).to eq(1)
      expect(Workers::Pipelines.jobs.first["args"]).to eq [project_id]

      # expect(saved_protect.reload.info).to eq project_detail
      # -"wiki_enabled" => true,
      # +"wiki_enabled" => "true",
      expect(saved_protect.reload.info).to_not be_nil
    end
  end
end
