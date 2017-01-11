module GitHub
  class Parser
    def initialize(data)
      @data = data
    end

    attr_reader :issue_number, :org_repo, :commit_sha, :type

    def parse
      if data[:action] == "opened" && data.key?(:pull_request)
        @issue_number = data[:number]
        @org_repo = data[:repository][:full_name]
        @commit_sha = data[:pull_request][:head][:sha]
        @type = :pull_request

      elsif data[:action] == 'synchronize' && data.key?(:pull_request)
        @issue_number = data[:number]
        @org_repo = data[:repository][:full_name]
        @type = :pull_request

      elsif data.key?(:issue)
        return "No number found in payload" unless data[:issue].key?(:number)

        @issue_number = data[:issue][:number]
        @org_repo = data[:repository][:full_name]
        @type = :issue

      else
        "No issue found in payload"
      end

      self
    end

    def pull_request?
      type == :pull_request
    end

    def issue?
      type == :issue
    end

    private

    attr_reader :data
  end
end
