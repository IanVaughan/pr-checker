class UnassignReviewers
  include Logging

  CONFIG_KEY = :review_matches

  def initialize(client, config, payload)
    @issue_assigner = IssueAssigner.new(client, config, payload)
    @payload = payload
    @config = config
  end

  def call(comments)
    comments.map do |sawer_comment|
      comment = sawer_comment.to_hash
      if any_match?(comment)
        user = extract_user_from(comment)
        next if user.nil?
        logger.debug "Removing assignee #{user}, from #{payload.to_s}"
        issue_assigner.unassign
      end
    end
  end

  private

  attr_reader :issue_assigner, :payload, :config

  def any_match?(comment)
    config[CONFIG_KEY].any? { |plus_one| comment[:body].match(plus_one) }
  end

  def extract_user_from(comment)
    comment.fetch(:user, {}).fetch(:login, nil)
  end
end
