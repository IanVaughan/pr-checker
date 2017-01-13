class StatusCreator # CreateStatus
  include Logging

  # Set build status to the PR
  # This can be used to prevent a merge on GitHub by setting a build status
  # check. If configured to be required then the merge button is disabled.
  # https://github.com/blog/1227-commit-status-api
  # https://developer.github.com/v3/repos/statuses/#create-a-status
  # https://help.github.com/articles/enabling-required-status-checks/
  #
  # status:
  #   context: 2+1s
  #   description: Require at least two people to add a +1
  #
  # The status to assign to the build status when in each stage
  # Stages are :
  #   initial - when the PR is raised, should it set the build status
  #   below - when matched comment count is below match_count
  #   pass - when matched comment count meets match_count
  # Valid values align with what GitHub support, these cannot be changed or styled
  #   none - do not set status
  #   failure - set failure status (shows with red cross)
  #   pending - set pending status (shows with amber dot)
  #   success - set success status (shows with green tick)
  #
  # eg
  # initial: failure
  # below: pending
  # pass: success

  CONFIG_KEY = :status

  def initialize(client, config, payload)
    @client, @payload = client, payload
    @config = config[CONFIG_KEY]
    @org_repo = payload.org_repo
    @commit_sha = payload.commit_sha
  end

  def initial
    create(config[:initial])
  end

  def pending
    create(config[:pending])
  end

  def success
    create(config[:success])
  end

  private

  attr_reader :client, :config, :payload, :org_repo, :commit_sha

  def create(status)
    logger.debug "Setting status:#{status}, on:#{payload.to_s}"
    client.create_status(
      org_repo, commit_sha, status, info
    )
  end

  def info
    {
      context: config[:context],
      description: config[:description],
      target_url: config[:target_url]
    }
  end
end
