module GitHub
  class Parser
    include Logging

    def initialize(client)
      @client = client
    end

    attr_reader :issue_number, :org_repo, :commit_sha, :type, :action

    def parse(data)
      @org_repo = data[:repository][:full_name]

      if data.key?(:pull_request)
        @issue_number = data[:number]
        @commit_sha = data[:pull_request][:head][:sha]
        @type = :pull_request
        @action = data[:action].to_sym
        logger.debug "#{self.class} Parsed pull_request:#{self.to_s}"

      elsif data.key?(:issue)
        if data[:issue].key?(:number)
        else
          logger.debug "No number found in payload" 
        end

        @issue_number = data[:issue][:number]
        @commit_sha = get_last_sha
        @type = :issue
        @action = data[:action] # delete
        logger.debug "Issue:#{self.to_s}"

      else
        logger.debug "No issue found in payload"
      end

      self
    end

    def valid?
      !type.nil?
    end

    def pull_request?
      type == :pull_request
    end

    def issue?
      type == :issue
    end

    def to_s
      "org_repo:#{org_repo}, issue:#{issue_number}, sha:#{commit_sha}, type:#{type}, action:#{action}"
    end

    private

    attr_reader :client

    def get_last_sha
      commits = client.pull_commits(org_repo, issue_number)
      commits.last[:sha]
    end
  end
end
