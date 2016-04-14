require 'json'

module PrChecker
  class Parser
    attr_reader :config, :client

    def initialize(config, client)
      @config, @client = config, client
    end

    def parse(request)
      data = JSON.parse(request.body.read)
      puts "payload:#{data}"
      return "No issue found in payload" unless data.key?("issue")
      return "No number found in payload" unless data["issue"].key?("number")

      issue_number = data["issue"]["number"]
      repo = data["repository"]["full_name"]
      puts "repo:#{repo}, issue_number:#{issue_number}"

      begin
        comments = client.issue_comments(repo, issue_number)
      rescue Octokit::NotFound => e
        puts "ERROR: cannot find issue. #{e}"
        return "Failed to get comments"
      end

      plus_one_count = comments.count { |c| c[:body].match config.plus_one_text }
      puts "repo:#{repo}, issue_number:#{issue_number}, count:#{plus_one_count}"

      commits = client.pull_commits repo, issue_number
      commit_sha = commits.last[:sha]
      info = { context: config.context, infomation: config.info }
      puts "commit:#{commit_sha}, info:#{info}"

      if plus_one_count > 1
        client.add_labels_to_an_issue(repo, issue_number, [config.ok_label])
        client.create_status(repo, commit_sha, 'success', info)
      else
        client.create_status(repo, commit_sha, 'pending', info)
      end
      puts "end..."
    end
  end
end
