module PrChecker
  class IssueAssigner
    def initialize(client)
      @client = client
    end

    def assign(org_repo, issue_number, assignees)
      client.post "/repos/#{org_repo}/issues/#{issue_number}/assignees", { assignees: assignees }
    end

    def unassign(org_repo, issue_number, assignees)
      client.delete "/repos/#{org_repo}/issues/#{issue_number}/assignees", { assignees: assignees }
    end

    private

    attr_reader :client
  end
end
