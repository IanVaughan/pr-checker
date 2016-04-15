require "logger"
require 'json'

module PrChecker
  class Parser
    attr_reader :config, :client

    def initialize(config, client)
      @config, @client = config, client
      # @log = File.new("log/sinatra.log", "a+")
      @logger = Logger.new(STDERR)
    end

    def parse(request)
      data = JSON.parse(request.body.read)
      return "No issue found in payload" unless data.key?("issue")
      return "No number found in payload" unless data["issue"].key?("number")

      issue_number = data["issue"]["number"]
      org_repo = data["repository"]["full_name"]

      begin
        comments = client.issue_comments(org_repo, issue_number)
      rescue Octokit::NotFound => e
        puts "ERROR: cannot find issue. #{e}"
        return "Failed to get comments"
      end

      @logger.warn "comments: #{comments.map { |c| c[:body] }}"

      plus_one_count = comments.count { |c| c[:body].match config.plus_one_text_regexp }
      plus_one_count += comments.count { |c| c[:body].match config.plus_one_emoji_regexp }

      commits = client.pull_commits org_repo, issue_number
      commit_sha = commits.last[:sha]
      info = { context: config.context, infomation: config.info }

      if plus_one_count > 1
        client.add_labels_to_an_issue(org_repo, issue_number, [config.ok_label])
        client.create_status(org_repo, commit_sha, 'success', info)
      else
        client.create_status(org_repo, commit_sha, 'pending', info)
      end
      plus_one_count
    end
  end
end
