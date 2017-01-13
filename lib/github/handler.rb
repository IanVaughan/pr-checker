require 'json'
require_relative 'client'
require_relative 'parser'
require 'pry'

# Main entry point from POST request
module GitHub
  class Handler
    include Logging

    def call(payload, client = nil)

      ## Temp read from master config, will read from DB via repo lookup
      master_config = MasterConfig.new
      client = client || Client.setup(master_config.access_token)

      data = Parser.new(client).parse(payload)
      unless data.valid?
        message = "Unknown payload"
        logger.warn message
        return message
      end

      # If its a issue, then there is no sha, so config file has to be read from master
      begin
        repo_config = ConfigReader.new(client).call(data.org_repo, data.commit_sha)
      rescue RuntimeError => e
        logger.warn "Returning now..."
        return "Unable to process #{data.to_s}"
      end


      assign_issue = IssueAssigner.new(client, repo_config, data)

      ## Loop unknown keys as review blocks
      config = repo_config[:reviewed]
      if config.nil?
        message = "No config for:#{data.to_s}"
        logger.warn message
        return message
      end
      create_status = ::StatusCreator.new(client, config, data)
      check_comments = ::CommentReceiver.new(client, config, data, assign_issue, create_status)

      if data.pull_request? && data.action == :open
        logger.debug "New PR:#{data.org_repo}, sha:#{data.commit_sha}"
        create_status.initial
        assign_issue.assign
      elsif data.action == :labeled
        # ignore
      else
        check_comments.call
      end
    end
  end
end
