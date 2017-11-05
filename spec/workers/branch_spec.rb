require 'spec_helper'

RSpec.describe Workers::Branch do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project.id, branch.name) }
  let(:project) { create_project }
  let(:branch) { create_branch(project) }

  describe '#perform' do
    context "other call with data" do
      it "saves" do
        perform

        # expect(project.reload.branches.last.name).to eq '123'
      end
    end
  end
end
