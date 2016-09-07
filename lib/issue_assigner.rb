class IssueAssigner

  def initialize(client, config)
    @client = client
    @config = config
  end

  def call(org_repo, issue_number)
    files = read_files_from(org_repo)
    return "Could not find files:#{config.assignees_filenames}" if files.empty?

    assignees = get_names_from(files)

    assign(org_repo, issue_number, assignees)
    "Assigned:#{assignees}, from files:#{config.assignees_filenames}"
  end

  def unassign(org_repo, issue_number, assignees)
    client.delete "/repos/#{org_repo}/issues/#{issue_number}/assignees", { assignees: assignees }
  end

  private

  attr_reader :client, :config

  def read_files_from(org_repo)
    config.assignees_filenames.map do |file|
      begin
        client.get "/repos/#{org_repo}/contents/#{file}"
        # TODO: client.contents org_repo, path: file
      rescue Octokit::NotFound
        puts "Could not find file:#{file} in:#{org_repo}"
      end
    end.compact
  end
  
  def get_names_from(files)
    files.flat_map do |file|
      Base64.decode64(file[:content]).split
    end.uniq
  end

  def assign(org_repo, issue_number, assignees)
    client.post "/repos/#{org_repo}/issues/#{issue_number}/assignees", { assignees: assignees }
  end
end
