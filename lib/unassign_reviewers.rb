class UnassignReviewers
  include Logging

  CONFIG_KEY = :matches

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
        if user.nil?
          logger.warn "#{self.class} Could not find user in comment:#{comment}, for:#{payload}"
          next
        end
        logger.debug "#{self.class} Removing assignee:#{user}, from:#{payload}"
        issue_assigner.unassign
      end
    end
  end

  private

  attr_reader :issue_assigner, :payload, :config

  def any_match?(comment)
    config_key.any? { |plus_one| comment[:body].match(plus_one) }
  end

  def config_key
    c = config[CONFIG_KEY]
    return c if c

    message = "#{self.class} Could not find key:#{CONFIG_KEY}, in:#{config}, for:#{payload}"
    logger.warn message
    return message
  end

  def extract_user_from(comment)
    comment.fetch(:user, {}).fetch(:login, nil)
  end
end
