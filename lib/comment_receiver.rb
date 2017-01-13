require './lib/unassign_reviewers'
require './lib/comment_counter'

class CommentReceiver # CheckComments
  include Logging

  def initialize(client, config, payload, issue_assigner, status_creator)
    @client = client
    @config = config
    @payload = payload
    @org_repo = payload.org_repo
    @issue_number = payload.issue_number

    @unassign_reviewers = UnassignReviewers.new(client, config, payload)
    @count_comments = CommentCounter.new(client, config, payload, status_creator)
  end

  def call
    comments = get_issue_comments(org_repo, issue_number)
    logger.debug "Found comments"
    return "Failed to get comments" if comments.nil?

    unassign_reviewers.call(comments)
    count_comments.call(comments)
  end

  private

  attr_reader :client, :count_comments, :unassign_reviewers, :config, :payload, :org_repo, :issue_number

  def get_issue_comments(org_repo, issue_number)
    logger.debug "Getting comments from repo:#{org_repo}, issue:#{issue_number}"
    client.issue_comments(org_repo, issue_number)
  rescue Octokit::NotFound => e
    logger.error "ERROR: cannot find issue for:#{org_repo}:#{issue_number}, error:#{e}"
    return "Failed to get comments for repo:#{org_repo}, issue:#{issue_number}"
  end
end
