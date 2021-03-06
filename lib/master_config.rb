class MasterConfig
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
    @access_token = ENV.fetch("PR_CHECKER_ACCESS_TOKEN", nil)
    @context = ENV.fetch("PR_CHECKER_CONTEXT", "No context configured")
    @info = ENV.fetch("PR_CHECKER_INFO", "No description configured")
  end
end
