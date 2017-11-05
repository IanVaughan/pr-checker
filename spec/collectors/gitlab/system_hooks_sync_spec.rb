require 'spec_helper'

RSpec.describe Gitlab::SystemHooksSync do
  let(:instance) { described_class.new }

  describe "#ensure_hook_present" do
    let(:ensure_hook_present) { instance.ensure_hook_present(url: url) }
    let(:url) { "http://foo.bar/hook" }

    context "when not present on gitlab" do
      before { expect_any_instance_of(Gitlab::SystemHooks).to receive(:get_hooks).and_return([]) }

      context "and not present locally" do
        it "creates on gitlab and saves locally" do
          expect_any_instance_of(Gitlab::SystemHooks).to receive(:add_hook).with(url).and_return(system_hook_fixture)
          expect { ensure_hook_present }.to change(SystemHook, :count).from(0).to(1)
          expect(SystemHook.last.url).to eq(system_hook_fixture[:url])
        end
      end

      context "and present locally" do
        let!(:system_hook) { create_system_hook }

        it "creates on gitlab" do
          expect_any_instance_of(Gitlab::SystemHooks).to receive(:add_hook).with(url).and_return(system_hook_fixture)
          expect { ensure_hook_present }.to_not change(SystemHook, :count).from(1)
          expect(SystemHook.last.url).to eq(system_hook_fixture[:url])
        end
      end
    end

    context "when present on gitlab" do
      before { expect_any_instance_of(Gitlab::SystemHooks).to receive(:get_hooks).and_return([system_hook_fixture]) }

      context "and not present locally" do
        it "creates locally" do
          expect_any_instance_of(Gitlab::SystemHooks).to_not receive(:add_hook)
          expect { ensure_hook_present }.to change(SystemHook, :count).from(0).to(1)
          expect(SystemHook.last.url).to eq(url)
        end
      end

      context "and present locally" do
        let!(:system_hook) { create_system_hook }

        it "does nothing" do
          expect_any_instance_of(Gitlab::SystemHooks).to_not receive(:add_hook)
          expect { ensure_hook_present }.to_not change(SystemHook, :count).from(1)
        end
      end
    end
  end
end
