require 'logger'
require 'json'
require './environment'

module PrChecker
  class Parser
    def initialize(logger, client)
      @logger = logger
      @client = client

      @issue_assigner = IssueAssigner.new(client)
      @status_creator = StatusCreator.new(client)
      @comment_receiver = CommentReceiver.new(client, logger, status_creator, issue_assigner)
    end

    def parse(data)
      if data.key?(:pull_request)
        return "No action on:#{data[:action]}" unless data[:action] == "opened"

        issue_number = data[:number]
        org_repo = data[:repository][:full_name]
        commit_sha = data[:pull_request][:head][:sha]
        logger.debug "New PR:#{org_repo}, sha:#{commit_sha}"

        c = config(org_repo)
        status_creator.fail(org_repo, commit_sha, c.reviewers)
        issue_assigner.assign(org_repo, issue_number, c.reviewers).tap do |assign_result|
          "org_repo:#{org_repo}, issue_number:#{issue_number}, assign:#{assign_result}"
        end
      else
        return "No issue found in payload" unless data.key?(:issue)
        return "No number found in payload" unless data[:issue].key?(:number)

        issue_number = data[:issue][:number]
        org_repo = data[:repository][:full_name]

        c = config(org_repo).reviewed
        comment_receiver.call(org_repo, issue_number, c)
      end
    end

    private

    attr_reader :logger, :client, :issue_assigner, :comment_receiver, :status_creator

    def config(org_repo)
      ConfigReader.new(client).get(org_repo)
    end
  end
end
