require 'spec_helper'
require 'json'

RSpec.describe Jira::Parser do
  let(:instance) { described_class.new(logger: logger) }

  context 'basic mock' do
    let(:parse) { instance.parse(payload) }
    let(:logger) { double 'Logger' }

    context "empty payload" do
      let(:payload) { {} }
      let(:message) { 'JiraParser found no changelog key in payload' }

      it "accepts payload" do
        expect(logger).to receive(:info).with(message)
        expect(parse).to eq message
      end
    end

    context "items in payload" do
      let(:payload) do
        {
          changelog: {
            items: [{
              field: 'status',
              fieldtype: 'jira',
              from: '6',
              fromString: 'Closed',
              to: '10009',
              toString: 'QA'
            }]
          }
        }
      end

      it "accepts payload" do
        expect(parse).to eq(from: 'Closed', to: 'QA')
      end
    end
  end
end
