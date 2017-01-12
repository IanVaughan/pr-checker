require 'logger'
require 'json'
require 'octokit'
require_relative 'parser'

module GitHub
  class Handler
    ACCESS_TOKEN = ENV["PR_CHECKER_ACCESS_TOKEN"]

    def initialize(client = nil)
      @logger = Logger.new(STDERR)
      @client = client || Client.setup(ACCESS_TOKEN)
      @config_file_loader = ConfigFileLoader.new(@client)
      @issue_assigner = IssueAssigner.new(@client)
    end

    def call(data)
      github_response = Parser.new(client)
      github_response.parse(data)

      config_file = load_config_file(github_response.org_repo)

      if github_response.pull_request?
        info = {
          context: config_file[:reviewed][:status][:context],
          description: config_file[:reviewed][:status][:description]
        }
        logger.debug "New PR:#{github_response.org_repo}, sha:#{github_response.commit_sha}"
        client.create_status(github_response.org_repo, github_response.commit_sha, 'pending', info)

        logger.debug "config_file:#{config_file}"
        assign_result = issue_assigner.call(github_response.org_repo, github_response.issue_number, config_file[:assignees])
        "org_repo:#{github_response.org_repo}, issue_number:#{github_response.issue_number}, assign:#{assign_result}"

      else
        action(github_response.issue_number, github_response.org_repo)
      end
    end

    private

    attr_reader :client, :logger, :issue_assigner, :config_file_loader

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

      return "Failed to get comments" if comments.nil?

      config_file = load_config_file(org_repo)

      logger.debug "#{org_repo}:#{issue_number} comments:#{comments}"
      comments.map do |comment|
        c = comment.to_hash
        config_file[:reviewed][:matches].each do |match|
          if c[:body].match(match)
            user = c.fetch(:user, {}).fetch(:login, nil)
            next if user.nil?
            logger.debug "#{org_repo}:#{issue_number} removing assignee #{user}"
            issue_assigner.unassign(org_repo, issue_number, user)
          end
        end
      end

      plus_one_count = comments.count do |c|
        config_file[:reviewed][:matches].each do |match|
          c[:body].match match
        end
      end

      logger.debug "#{org_repo}:#{issue_number} comments: #{comments.map { |c| c[:body] }} plus_one_count:#{plus_one_count}"

      commits = client.pull_commits(org_repo, issue_number)
      commit_sha = commits.last[:sha]

      info = {
        context: config_file[:reviewed][:status][:context],
        description: config_file[:reviewed][:status][:description]
      }

      if plus_one_count > config_file[:reviewed][:count]
        logger.debug "#{org_repo}:#{issue_number} adding labels and pass status"
        label = config_file[:reviewed][:label][:text]
        client.add_labels_to_an_issue(org_repo, issue_number, [label])
        status = config_file[:reviewed][:status][:pass]
        client.create_status(org_repo, commit_sha, status, info)
      else
        logger.debug "#{org_repo}:#{issue_number} setting pending below check"
        status = config_file[:reviewed][:status][:below]
        client.create_status(org_repo, commit_sha, status, info)
      end

      "Found #{plus_one_count} +1s on ##{issue_number} of:#{org_repo} at:#{commit_sha}"
    end
  end
end
