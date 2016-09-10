# envconfig
require "dotenv"

module PrChecker
  class Config
    attr_reader :access_token

    def initialize
      load_env
    end

    def load_env
      Dotenv.load
      @access_token = ENV.fetch("PR_CHECKER_ACCESS_TOKEN")
    end
  end
end
