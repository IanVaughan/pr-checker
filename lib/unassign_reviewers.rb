class UnassignReviewers
  def initialize(logger, issue_assigner, org_repo, issue_number, config)
    @logger = logger
    @issue_assigner = issue_assigner
  end

  def call(comments)
    comments.map do |sawer_comment|
      comment = sawer_comment.to_hash
      if any_match?(comment, config)
        user = extract_user_from(comment)
        next if user.nil?
        logger.debug "#{org_repo}:#{issue_number} removing assignee #{user}"
        issue_assigner.unassign
      end
    end
  end

  private

  attr_reader :issue_assigner, :logger

  def any_match?(comment, config)
    config[:review_matches].any? { |plus_one| comment[:body].match(plus_one) }
  end

  def extract_user_from(comment)
    comment.fetch(:user, {}).fetch(:login, nil)
  end
end
