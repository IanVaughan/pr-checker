class IssueAssigner
  include Logging

  CONFIG_KEY = :assigness

  def initialize(client, config, payload)
    @client = client
    @payload = payload
    @org_repo = payload.org_repo
    @issue_number = payload.issue_number
    @assignees = config[CONFIG_KEY]
    raise "Config assignees block empty" if config.nil?
  end

  def assign
    client.post(
      "/repos/#{org_repo}/issues/#{issue_number}/assignees", 
      assignees: assignees
    )
    message = "Assigned:#{assignees}, to:#{payload.to_s}"
    logger.debug message
    message
  rescue => e
    message = "Failed to assign #{payload.to_s} due to #{e}"
    logger.error message
    message
  end

  def unassign
    client.delete "/repos/#{org_repo}/issues/#{issue_number}/assignees", { assignees: assignees }
    "Unassigned:#{assignees}"
  end

  private

  attr_reader :client, :org_repo, :issue_number, :assignees, :payload
end
