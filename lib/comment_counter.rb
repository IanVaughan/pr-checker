class CommentCounter # StatusCreator # UpdateStaus
  include Logging

  CONFIG_KEY = :matches

  def initialize(client, config, payload, status_creator)
    @client = client
    @config = config
    @payload = payload
    @org_repo = payload.org_repo
    @issue_number = payload.issue_number
    @status_creator = status_creator
  end

  def call(comments)
    plus_one_count = count_matches(comments)
    sha = get_last_commit_sha(org_repo, issue_number)

    if plus_one_count >= config[:count]
      logger.debug "Adding labels and success status to:#{payload}"
      label = config[:label][:text]
      color = config[:label][:colour]
      client.update_label(org_repo, label, { color: 'f29513' })
      client.add_labels_to_an_issue(org_repo, issue_number, [label])

      status_creator.success
    else
      logger.debug "Setting pending status to:#{payload.to_s}"
      status_creator.pending
    end

    "Found #{plus_one_count} +1s on ##{issue_number} of:#{org_repo} at:#{sha}"
  end

  private

  attr_reader :client, :config, :status_creator, :org_repo, :issue_number, :payload

  def count_matches(comments)
    comments.count { |comment| any_match?(comment) }
  end

  def any_match?(comment)
    c = config[CONFIG_KEY]
    if c.nil?
      message = "Could not find config '#{CONFIG_KEY}' in #{config}, for:#{payload}"
      logger.warn message
      return message
    end
    c.any? { |plus_one| comment[:body].match(plus_one) }
  end

  def get_last_commit_sha(org_repo, issue_number)
    client.pull_commits(org_repo, issue_number).last[:sha]
  end
end
