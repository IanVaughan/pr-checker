require 'octokit'

class Client
  def self.setup(access_token)
    client = Octokit::Client.new(access_token: access_token)
    begin
      # client.user # assert access is working otherwise will raise
    rescue Octokit::Unauthorized
      puts "ACCESS_TOKEN does not work! I don't have access. #{access_token}"
      exit
    end
    client
  end

  def read_file_from_repo(filename, org_repo, branch = nil)
    client.contents org_repo, path: filename + (branch ? "?ref=#{branch}" : '')
  rescue Octokit::NotFound
    message = "Could not find file:#{filename} in:#{org_repo}"
    raise message
  end
end
