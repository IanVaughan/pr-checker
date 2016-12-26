require 'logger'
require 'json'
require 'octokit'
require 'github/parser'

module GitHub
  class Handler
    def initialize(config = nil, client = nil)
      @logger = Logger.new(STDERR)
      @config = config || MasterConfig.new
      @client = client || Client.setup(@config.access_token)
      @config_file_loader = ConfigFileLoader.new(@client)
      @issue_assigner = IssueAssigner.new(@client)
    end

    def call(data)
      github_response = Parser.new(data)
      github_response.parse

      if github_response.pull_request?
        info = { context: config.context, description: config.info }
        logger.debug "New PR:#{github_response.org_repo}, sha:#{github_response.commit_sha}"
        client.create_status(github_response.org_repo, github_response.commit_sha, 'pending', info)

        config_file = load_config_file(github_response.org_repo)
        logger.debug "config_file:#{config_file}"
        assign_result = issue_assigner.call(github_response.org_repo, github_response.issue_number, config_file[:assignees])
        "org_repo:#{github_response.org_repo}, issue_number:#{github_response.issue_number}, assign:#{assign_result}"

      else
        action(github_response.issue_number, github_response.org_repo)
      end
    end

    private

    attr_reader :config, :client, :logger, :issue_assigner, :config_file_loader

    def load_config_file(org_repo, branch = nil)
      config_file_loader.load(org_repo, branch)
    end

    def action(issue_number, org_repo)
      logger.debug "Getting comments from:#{org_repo}:#{issue_number}"
      begin
        comments = client.issue_comments(org_repo, issue_number)
      rescue Octokit::NotFound => e
        logger.error "ERROR: cannot find issue. #{e}"
        return "Failed to get comments"
      end

      logger.debug "#{org_repo}:#{issue_number} comments:#{comments}"
      comments.map do |comment|
        c = comment.to_hash
        if c[:body].match(config.plus_one_emoji_regexp) || c[:body].match(config.plus_one_text_regexp)
          user = c.fetch(:user, {}).fetch(:login, nil)
          next if user.nil?
          logger.debug "#{org_repo}:#{issue_number} removing assignee #{user}"
          issue_assigner.unassign(org_repo, issue_number, user)
        end
      end

      plus_one_count = comments.count { |c| c[:body].match config.plus_one_text_regexp }
      plus_one_count += comments.count { |c| c[:body].match config.plus_one_emoji_regexp }

      logger.debug "#{org_repo}:#{issue_number} comments: #{comments.map { |c| c[:body] }} plus_one_count:#{plus_one_count}"

      commits = client.pull_commits(org_repo, issue_number)
      commit_sha = commits.last[:sha]
      info = { context: config.context, description: config.info }

      if plus_one_count > 1
        logger.debug "#{org_repo}:#{issue_number} adding labels and success status"
        client.add_labels_to_an_issue(org_repo, issue_number, [config.ok_label])
        client.create_status(org_repo, commit_sha, 'success', info)
      else
        logger.debug "#{org_repo}:#{issue_number} setting pending status check"
        client.create_status(org_repo, commit_sha, 'pending', info)
      end

      "Found #{plus_one_count} +1s on ##{issue_number} of:#{org_repo} at:#{commit_sha}"
    end
  end
end
