class IssueAssigner
  def initialize(client, config)
    @client = client
    @config = config
  end

  def call(org_repo, issue_number)
    assign(org_repo, issue_number, config.assignees)
    "Assigned:#{config.assignees}"
  end

  def unassign(org_repo, issue_number, assignees)
    client.delete "/repos/#{org_repo}/issues/#{issue_number}/assignees", { assignees: assignees }
  end

  private

  attr_reader :client, :config

  def assign(org_repo, issue_number, assignees)
    client.post "/repos/#{org_repo}/issues/#{issue_number}/assignees", { assignees: assignees }
  end
end
