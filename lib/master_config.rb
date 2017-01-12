require "dotenv"

class MasterConfig
  attr_reader :access_token

  def initialize
    Dotenv.load
    # GITHUB_APP_TOKEN
    @access_token = ENV["PR_CHECKER_ACCESS_TOKEN"]
  end
end
