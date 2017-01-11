class IssueAssigner
  def initialize(client, config, payload)
    @client, @config, @payload = client, config, payload
  end

  def assign #(org_repo, issue_number, assignees)
    client.post(
      "/repos/#{org_repo}/issues/#{issue_number}/assignees", 
      assignees: assignees
    )
    "Assigned:#{assignees}"
  end

  def unassign # (org_repo, issue_number, assignees)
    client.delete "/repos/#{org_repo}/issues/#{issue_number}/assignees", { assignees: assignees }
    "Unassigned:#{assignees}"
  end

  private

  attr_reader :client, :config, :payload
  # delegate :org_repo, :issue_number, to: :payload
  # delegate :assignees, to: :config
  def org_repo
    payload.org_repo
  end
  def issue_number
    payload.issue_number
  end
  def assignees
    config[:assignees]
  end
end
