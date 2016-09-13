class IssueAssigner

  def initialize(client, config)
    @client = client
    @config = config
  end

  def call(org_repo, issue_number)
    assignees = get_names_from(files)

    assign(org_repo, issue_number, assignees)
    "Assigned:#{assignees}"
  end

  def unassign(org_repo, issue_number, assignees)
    client.delete "/repos/#{org_repo}/issues/#{issue_number}/assignees", { assignees: assignees }
  end

  private

  attr_reader :client, :config

  def get_names_from(files)
    files.flat_map do |file|
      Base64.decode64(file[:content]).split
    end.uniq
  end

  def assign(org_repo, issue_number, assignees)
    client.post "/repos/#{org_repo}/issues/#{issue_number}/assignees", { assignees: assignees }
  end
end
