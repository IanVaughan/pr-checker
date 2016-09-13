class IssueAssigner
  def initialize(client)
    @client = client
  end

  def call(org_repo, issue_number, assignees)
    client.post "/repos/#{org_repo}/issues/#{issue_number}/assignees", { assignees: assignees }
    "Assigned:#{assignees}"
  end

  def unassign(org_repo, issue_number, assignees)
    client.delete "/repos/#{org_repo}/issues/#{issue_number}/assignees", { assignees: assignees }
    "Unassigned:#{assignees}"
  end

  private

  attr_reader :client
end
