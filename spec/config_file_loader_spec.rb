require 'spec_helper'

RSpec.describe ConfigFileLoader do
  let(:instance) { described_class.new(client) }
  let(:client) { double PrChecker::Remote }
  # let(:client) { PrChecker::Remote.setup('849ac993d373f8125ca17b5dec98bed971f0d177') }

  describe '#get' do
    subject { instance.get(org_repo) }
    let(:org_repo) { 'OrgName/RepoName' }
    # let(:path) { "/repos/#{org_repo}/contents/#{described_class::CONFIG_FILENAME}" }

    context 'when no config file is found in the repo' do
      it 'returns a error key hash so it can be shown in github hooks Web UI' do
        expect(client).to receive(:contents).with(org_repo, path: described_class::CONFIG_FILENAME).and_raise(Octokit::NotFound)

        is_expected.to eq(error: "Could not find file:#{described_class::CONFIG_FILENAME} in:#{org_repo}")
      end
    end

    context 'when the config file is found' do
      let(:get_contents) { load_fixture('get_contents') }
      let(:config_file) do
        {
          reviewers: [ 'Paul', 'Simon' ]
        }
      end

      it 'loads the class ivars with the config from the file' do
        expect(client).to receive(:contents).with(org_repo, path: described_class::CONFIG_FILENAME).and_return(get_contents)

        is_expected.to eq(config_file)
        expect(instance.config).to eq(config_file)
      end
    end
  end
end
