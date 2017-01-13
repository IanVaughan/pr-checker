module GitHub
  class Parser
    include Logging

    def initialize(data)
      @data = data
    end

    attr_reader :issue_number, :org_repo, :commit_sha, :type, :action

    def parse
      @org_repo = data[:repository][:full_name]

      if data.key?(:pull_request)
        @issue_number = data[:number]
        @commit_sha = data[:pull_request][:head][:sha]
        @type = :pull_request
        @action = data[:action].to_sym
        logger.debug "PR:#{self.to_s}"

      elsif data.key?(:issue)
        if data[:issue].key?(:number)
        else
          logger.debug "No number found in payload" 
        end

        @issue_number = data[:issue][:number]
        @commit_sha = nil
        @type = :issue
        @action = data[:action] # delete
        logger.debug "Issue:#{self.to_s}"

      else
        logger.debug "No issue found in payload"
      end

      self
    end

    def valid?
      !data.empty?
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

    attr_reader :data
  end
end
