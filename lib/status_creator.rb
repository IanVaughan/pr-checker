class StatusCreator
  def initialize(client)
    @client = client
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

  attr_reader :client

  def create(org_repo, commit_sha, status, config)
    client.create_status(
      org_repo,
      commit_sha,
      status,
      info(config)
    )
  end

  def info(config)
    {
      context: config[:status][:context],
      description: config[:status][:description]
    }
  end
end
