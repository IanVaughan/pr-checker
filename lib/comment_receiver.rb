require './lib/unassign_reviewers'
require './lib/comment_counter'

class CommentReceiver # CheckComments
  def initialize(client, logger, repo_config, payload)
    @client = client
    @logger = logger
    @config = repo_config
    @payload = payload

    @unassign_reviewers = UnassignReviewers.new(logger)
    @count_comments = CommentCounter.new(logger, client)
  end

  def call
    comments = get_issue_comments(org_repo, issue_number)
    logger.debug "#{org_repo}:#{issue_number} found comments:#{comments}"
    return "Failed to get comments" if comments.nil?

    unassign_reviewers.call(comments)
    count_comments.call(comments)
  end

  private

  attr_reader :client, :logger, :count_comments, :unassign_reviewers, :config, :payload
  # delegate :org_repo, :issue_number, to: :payload
  def org_repo
    payload.org_repo
  end
  def issue_number
    payload.issue_number
  end

  def get_issue_comments(org_repo, issue_number)
    logger.debug "Getting comments from repo:#{org_repo}, issue:#{issue_number}"
    client.issue_comments(org_repo, issue_number)
  rescue Octokit::NotFound => e
    logger.error "ERROR: cannot find issue for:#{org_repo}:#{issue_number}, error:#{e}"
    return "Failed to get comments for repo:#{org_repo}, issue:#{issue_number}"
  end
end
