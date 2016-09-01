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

  context "data in payload" do
    before do
      allow(config).to receive(:plus_one_text_regexp).and_return(Regexp.quote(":+1:"))
      # allow(config).to receive(:plus_one_emoji_regexp).and_return(Regexp.quote("\xF0\x9F\x91\x8D"))
      allow(config).to receive(:plus_one_emoji_regexp).and_return("\u{1F44D}")
      allow(config).to receive(:context).and_return("context")
      allow(config).to receive(:info).and_return("info")
      allow(config).to receive(:ok_label).and_return("ok_label")
    end

    let(:org_repo) { "MyOrg/MyRepo" }
    let(:issue) { 22 }

    let(:payload) do
      {
        "issue" => { "number" => issue },
        "repository" => { "full_name" => org_repo }
      }
    end

    let(:commit) { { sha: sha } }
    let(:sha) { "abc123" }
    let(:info) { { context: "context", infomation: "info" } }

    context "when no +1" do
      let(:comments) { [{ body: "Meh" }] }

      it "accepts payload" do
        expect(client).to receive(:issue_comments).with(org_repo, issue).and_return(comments)
        expect(client).to receive(:pull_commits).with(org_repo, issue).and_return([commit])
        expect(client).to receive(:create_status).with(org_repo, sha, "pending", info)
        expect(parse).to eq 0
      end
    end

    context "when 1 +1" do
      let(:comments) { [{ body: "Yeah :+1: ok" }] }

      it "accepts payload" do
        expect(client).to receive(:issue_comments).with(org_repo, issue).and_return(comments)
        expect(client).to receive(:pull_commits).with(org_repo, issue).and_return([commit])
        expect(client).to receive(:create_status).with(org_repo, sha, "pending", info)
        expect(parse).to eq 1
      end
    end

    context "when 1 +1 is emoji" do
      let(:comments) { [{ body: "Yeah 👍  ok" }] }

      it "accepts payload" do
        expect(client).to receive(:issue_comments).with(org_repo, issue).and_return(comments)
        expect(client).to receive(:pull_commits).with(org_repo, issue).and_return([commit])
        expect(client).to receive(:create_status).with(org_repo, sha, "pending", info)
        expect(parse).to eq 1
      end
    end

    context "when 1 +1 is emoji encoded" do
      let(:comments) { [{ body: "Yeah \u{1F44D} ok" }] }

      it "accepts payload" do
        expect(client).to receive(:issue_comments).with(org_repo, issue).and_return(comments)
        expect(client).to receive(:pull_commits).with(org_repo, issue).and_return([commit])
        expect(client).to receive(:create_status).with(org_repo, sha, "pending", info)
        expect(parse).to eq 1
      end
    end

    context "when 2 +1" do
      let(:comments) do
        [
          { body: "Yeah :+1: ok" },
          { body: "Yeah 👍  ok" }
        ]
      end

      let(:labels) { ["ok_label"] }

      it "accepts payload" do
        expect(client).to receive(:issue_comments).with(org_repo, issue).and_return(comments)
        expect(client).to receive(:pull_commits).with(org_repo, issue).and_return([commit])
        expect(client).to receive(:add_labels_to_an_issue).with(org_repo, issue, labels)
        expect(client).to receive(:create_status).with(org_repo, sha, "success", info)
        expect(parse).to eq 2
      end
    end
  end
end
