require 'spec_helper'
require 'json'

RSpec.describe ConfigReader do
  let(:instance) { described_class.new(client) }
  let(:client) { double PrChecker::Remote }
  # let(:client) { PrChecker::Remote.setup('849ac993d373f8125ca17b5dec98bed971f0d177') }

  describe '#call' do
    let(:org_repo) { 'OrgName/RepoName' }
    subject { instance.fetch_from_repo(org_repo) }
    let(:path) { "/repos/#{org_repo}/contents/#{ConfigFile::CONFIG_FILENAME}" }

    context 'when no config file is found in the repo' do
      it 'returns a error key hash so it can be shown in github hooks Web UI' do
        expect(client).to receive(:contents).with(org_repo, path: ConfigFile::CONFIG_FILENAME).and_raise(Octokit::NotFound)

        is_expected.to eq(error: "Could not find file:#{ConfigFile::CONFIG_FILENAME} in:#{org_repo}")
      end
    end

    context 'when the config file is found' do
      let(:get_contents) { load_fixture('get_contents') }
      let(:config_file) do
        {
          reviewers: [ 'Paul', 'Simon', ],
          reviewed: {
            review_matches: [ ':+1:', '\\u{1F44D}', '👍'],
            match_count: 2,
            label: {
              text: '+2d',
              colour: '009800'
            },
            status: {
              context: '2+1s',
              description: 'Require at least two people to add a +1'
            }
          }
        }
      end

      it 'loads the class ivars with the config from the file' do
        expect(client).to receive(:contents).with(org_repo, path: ConfigFile::CONFIG_FILENAME).and_return(get_contents)

        is_expected.to eq(ok: config_file)
      end
    end
  end
end
