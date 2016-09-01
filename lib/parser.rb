require "logger"
require 'json'

module PrChecker
  class Parser
    attr_reader :config, :client

    def initialize(config, client)
      @config, @client = config, client
      @logger = Logger.new(STDERR)
    end

    def parse(data)
      if data.key?(:pull_request)
        return "No action on:#{data["action"]}" unless data["action"] == "opened"
        issue_number = data["number"]
        org_repo = data["repository"]["full_name"]
        commit_sha = data["pull_request"]["head"]["sha"]

        info = { context: config.context, information: config.info }
        client.create_status(org_repo, commit_sha, 'failure', info)
      else
        return "No issue found in payload" unless data.key?(:issue)
        return "No number found in payload" unless data[:issue].key?(:number)

        issue_number = data[:issue][:number]
        org_repo = data[:repository][:full_name]
        action(issue_number, org_repo)
      end
    end

    def action(issue_number, org_repo)
      begin
        comments = client.issue_comments(org_repo, issue_number)
      rescue Octokit::NotFound => e
        puts "ERROR: cannot find issue. #{e}"
        return "Failed to get comments"
      end

      @logger.debug "comments: #{comments.map { |c| c[:body] }}"

      plus_one_count = comments.count { |c| c[:body].match config.plus_one_text_regexp }
      plus_one_count += comments.count { |c| c[:body].match config.plus_one_emoji_regexp }

      commits = client.pull_commits(org_repo, issue_number)
      commit_sha = commits.last[:sha]
      info = { context: config.context, information: config.info }

      if plus_one_count > 1
        client.add_labels_to_an_issue(org_repo, issue_number, [config.ok_label])
        client.create_status(org_repo, commit_sha, 'success', info)
      else
        client.create_status(org_repo, commit_sha, 'pending', info)
      end

      "Found #{plus_one_count} +1s on ##{issue_number} of:#{org_repo} at:#{commit_sha}"
    end
  end
end
