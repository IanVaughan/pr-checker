require 'spec_helper'
# require 'json'

RSpec.describe ConfigReader do
  let(:instance) { described_class.new(client) }
  let(:client) { double Client }

  describe '#call' do
    let(:call) { instance.call(org_repo) }
    let(:org_repo) { 'IanVaughan/pr-checker' }
    let(:path) { "/repos/#{org_repo}/contents/#{described_class::CONFIG_FILENAME}" }

    context 'when no config file is found in the repo' do
      subject { call }

      it 'returns a error key hash so it can be shown in github hooks Web UI' do
        expect(client).to receive(:contents).with(
          org_repo, path: described_class::CONFIG_FILENAME
        ).and_raise(Octokit::NotFound)

        is_expected.to eq("Could not find file:#{described_class::CONFIG_FILENAME} in:#{org_repo}")
      end
    end

    context 'when the config file is found' do
      subject { call.to_h }
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
        expect(client).to receive(:contents).with(
          org_repo, path: described_class::CONFIG_FILENAME
        ).and_return(get_contents)

        is_expected.to eq config_file
      end
    end
  end
end
