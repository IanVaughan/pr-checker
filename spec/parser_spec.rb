require "spec_helper"
require "json"
require File.expand_path("../../lib/parser", __FILE__)

RSpec.describe PrChecker::Parser do
  let(:instance) { PrChecker::Parser.new(config, client) }
  let(:config) { double "Config" }
  let(:client) { double "Client" }
  subject(:parse) { instance.parse(response) }
  let(:response) { OpenStruct.new(body: body) }
  let(:body) { OpenStruct.new(read: payload.to_json) }

  context "empty payload" do
    let(:payload) { {} }

    it "accepts payload" do
      expect(parse).to eq "No issue found in payload"
    end
  end

  context "no number in payload" do
    let(:payload) { { "issue" => {} } }

    it "accepts payload" do
      expect(parse).to eq "No number found in payload"
    end
  end

  context "number in payload" do
    before do 
      allow(config).to receive(:plus_one_text).and_return(":+1:")
    end

    let(:org_repo) { "MyOrg/MyRepo" }
    let(:issue) { 22 }

    let(:payload) do
      {
        "issue" => { "number" => issue },
        "repository" => { "full_name" => org_repo }
      }
    end

    let(:comment1) { { body: "Yeah :+1: cool" } }

    it "accepts payload" do
      expect(client).to receive(:issue_comments).with(org_repo, issue).and_return([comment1])
      expect(client).to receive(:pull_commits).with(org_repo, issue).and_return("ddd")
      expect(parse).to eq "No number found in payload"
    end
  end
end
