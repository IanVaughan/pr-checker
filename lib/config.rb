module PrChecker
  class Config
    attr_reader :plus_one_text, :ok_label, :access_token, :context, :info

    def initialize
      load_env
    end

    def load_env
      @plus_one_text = ENV["PR_CHECKER_PLUS_ONE_TEXT"]
      @ok_label = ENV["PR_CHECKER_OK_LABEL"]
      @access_token = ENV["PR_CHECKER_ACCESS_TOKEN"]
      @context = ENV["PR_CHECKER_CONTEXT"]
      @info = ENV["PR_CHECKER_INFO"]

      puts "Read from env:"
      puts "PLUS_ONE_TEXT: #{@plus_one_text}"
      puts "OK_LABEL: #{@ok_label}"
      puts "ACCESS_TOKEN: #{@access_token}"
      puts "CONTEXT: #{@context}"
      puts "INFO: #{@info}"
    end
  end
end
