require 'logger'
require 'json'
require_relative 'client'
require_relative 'parser'

module GitHub
  class Handler
    def self.call(data, client = nil)
      logger = Logger.new(STDERR)
      payload = Parser.new(data).parse

      ## Temp read from master config, will read from DB via repo lookup
      master_config = MasterConfig.new
      client = client || Client.setup(master_config.access_token)

      repo_config = ConfigReader.new(client).call(payload.org_repo)

      ## Loop unknown keys as review blocks

      assign_issue = IssueAssigner.new(client, repo_config[:assignees], payload)
      create_status = StatusCreator.new(client, repo_config[:reviewed], payload)
      check_comments = CommentReceiver.new(client, logger, repo_config[:reviewed], payload)

      if payload.pull_request?
        logger.debug "New PR:#{payload.org_repo}, sha:#{payload.commit_sha}"
        create_status.initial
        assign_issue.assign
      else
        check_comments.call
      end
    end
  end
end
