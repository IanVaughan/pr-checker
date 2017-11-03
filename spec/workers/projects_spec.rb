require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::Projects do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform }

  describe '#perform' do
    context "with new unseen projects", sidekiq: :fake do
      let(:project1) { load_fixture_yml('gitlab/formatted/project1.yml') }
      let(:project2) { load_fixture_yml('gitlab/formatted/project2.yml') }

      it "saves them both" do
        expect_any_instance_of(Gitlab::Projects).to receive(:call).and_return([project1, project2])

        expect { perform }.to change { ::Project.count }.from(0).to(2)
      end

      it "enqueues Project sidekiq worker" do
        expect_any_instance_of(Gitlab::Projects).to receive(:call).and_return([project1, project2])

        expect { perform }.to change(Workers::Project.jobs, :size).from(0).to(2)
      end
    end

    context "with existing seen projects", sidekiq: :fake do
      let(:project1) { load_fixture_yml('gitlab/formatted/project1.yml') }

      before { Project.create!(project1.merge(description: "old description")) }

      it "updates it" do
        expect_any_instance_of(Gitlab::Projects).to receive(:call).and_return([project1])

        expect { perform }.to_not change { ::Project.count }.from(1)
        expect(Project.find(project1[:id]).description).to eq project1[:description]
      end
    end
  end
end
