require 'json'
require_relative 'client'
require_relative 'parser'
require 'pry'

# Main entry point from POST request
module GitHub
  class Handler
    include Logging

    def call(payload, client = nil)
      data = Parser.new(payload).parse
      return "Unknown payload" unless data.valid?

      ## Temp read from master config, will read from DB via repo lookup
      master_config = MasterConfig.new
      client = client || Client.setup(master_config.access_token)

      begin
        repo_config = ConfigReader.new(client).call(data.org_repo, data.commit_sha)
      rescue RuntimeError => e
        logger.warn "Returning now..."
        return "Unable to process #{data.to_s}"
      end

      ## Loop unknown keys as review blocks

      assign_issue = IssueAssigner.new(client, repo_config, data)
      create_status = ::StatusCreator.new(client, repo_config[:reviewed], data)
      check_comments = ::CommentReceiver.new(client, repo_config[:reviewed], data, assign_issue)

      if data.pull_request?
        logger.debug "New PR:#{data.org_repo}, sha:#{data.commit_sha}"
        create_status.initial
        assign_issue.assign
      else
        check_comments.call
      end
    end
  end
end
