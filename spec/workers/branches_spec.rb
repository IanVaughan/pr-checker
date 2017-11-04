require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::Branches do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project.id, page) }
  let!(:project) { create_project }

  describe '#perform', sidekiq: :fake do
    let(:page) { nil }

    context "first call" do
      it "saves" do
        expect_any_instance_of(Gitlab::Branches).to receive(:call).and_return([branch_fixture])

        perform

        expect(Workers::Branch.jobs.size).to eq(1)
        expect(Workers::Branch.jobs.first["args"]).to eq [project.id, branch_fixture[:id]]

        expect(project.reload.branches.last.name).to eq branch_fixture[:name]
      end
    end

    context "other call with data" do
      let!(:branch) { create_branch(project) }
      let(:page) { 2 }

      it "saves" do
        expect_any_instance_of(Gitlab::Branches).to receive(:call).and_return([branch_fixture.merge(name: '123')])

        perform

        expect(Workers::Branch.jobs.size).to eq(1)
        expect(Workers::Branch.jobs.first["args"]).to eq [project.id, branch_fixture[:id]]

        expect(project.reload.branches.last.name).to eq '123'
      end
    end

    context "other call with no data" do
      let!(:branch) { create_branch(project) }
      let(:page) { 3 }

      it "saves" do
        expect_any_instance_of(Gitlab::Branches).to receive(:call).and_return([])

        perform

        expect(Workers::Branch.jobs.size).to eq(0)
      end
    end
  end
end
