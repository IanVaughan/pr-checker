require "dotenv"

module PrChecker
  class Config
    attr_reader :plus_one_text, :plus_one_text_regexp, :plus_one_emoji_regexp
    attr_reader :ok_label, :access_token, :context, :info

    def initialize
      load_env
    end

    def load_env
      Dotenv.load
      # GITHUB_APP_TOKEN
      @plus_one_text = ENV.fetch("PR_CHECKER_PLUS_ONE_TEXT", ":+1:")
      @plus_one_text_regexp = Regexp.quote @plus_one_text
      @plus_one_emoji_regexp = ENV.fetch("PR_CHECKER_PLUS_ONE_EMOJI", "👍 ")
      @ok_label = ENV.fetch("PR_CHECKER_OK_LABEL", "+2d")
      @access_token = ENV.fetch("PR_CHECKER_ACCESS_TOKEN")
      @context = ENV.fetch("PR_CHECKER_CONTEXT", "No context configured")
      @info = ENV.fetch("PR_CHECKER_INFO", "No info configured")

      puts "Read from env:"
      puts "PLUS_ONE_TEXT: #{@plus_one_text}"
      puts "OK_LABEL: #{@ok_label}"
      puts "ACCESS_TOKEN: #{@access_token}"
      puts "CONTEXT: #{@context}"
      puts "INFO: #{@info}"
    end
  end
end
