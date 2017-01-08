require './lib/unassign_reviewers'
require './lib/comment_counter'

class CommentReceiver
  def initialize(client, logger, status_creator, issue_assigner)
    @client = client
    @logger = logger
    @status_creator = status_creator

    @unassign_reviewers = UnassignReviewers.new(logger, issue_assigner)
    @comment_counter = CommentCounter.new(logger, client, status_creator)
  end

  def call(org_repo, issue_number, config)
    comments = get_issue_comments(org_repo, issue_number)
    logger.debug "#{org_repo}:#{issue_number} found comments:#{comments}"

    unassign_reviewers.call(comments, org_repo, issue_number, config)
    comment_counter.call(comments, org_repo, issue_number, config)
  end

  private

  attr_reader :client, :logger, :comment_counter, :unassign_reviewers

  def get_issue_comments(org_repo, issue_number)
    client.issue_comments(org_repo, issue_number)
  rescue Octokit::NotFound => e
    logger.error "ERROR: cannot find issue for:#{org_repo}:#{issue_number}, error:#{e}"
    # return "Failed to get comments for:#{org_repo}:#{issue_number}"
    raise 'foo'
  end
end
