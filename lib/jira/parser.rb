module Jira
  class Parser
    def initialize(logger:)
      @logger = logger
    end
    
    def parse(data)
      if data.key?(:changelog)
        items = data[:changelog][:items]
        item = items.first
        { from: item[:fromString], to: item[:toString] }
      else
        message = "JiraParser found no changelog key in payload"
        logger.info message
        return message
      end
    end

    private

    attr_reader :logger
  end
end
