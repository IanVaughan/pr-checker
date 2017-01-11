class StatusCreator # CreateStatus
  def initialize(client, repo_config, payload)
    @client, @repo_config, @payload = client, repo_config, payload
  end

  def initial
    create(
      payload.org_repo, payload.commit_sha, 
      repo_config[:intial], info(repo_config)
    )
  end

  def success(org_repo, commit_sha, config)
    create(org_repo, commit_sha, 'success', config)
  end

  def pending(org_repo, commit_sha, config)
    create(org_repo, commit_sha, 'pending', config)
  end

  def fail(org_repo, commit_sha, config)
    create(org_repo, commit_sha, 'failure', config)
  end

  private

  attr_reader :client, :repo_config, :payload

  def create(org_repo, commit_sha, status, config)
    logger.debug "Setting status:#{org_repo}, sha:#{commit_sha}, status:#{status}"
    client.create_status(
      org_repo, commit_sha, status, info(config)
    )
  end

  def info(config)
    {
      context: config[:status][:context],
      description: config[:status][:description]
    }
  end
end
