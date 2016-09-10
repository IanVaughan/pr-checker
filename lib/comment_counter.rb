module PrChecker
  class CommentCounter
    def initialize(logger, client, status_creator)
      @logger = logger
      @client = client
      @status_creator = status_creator
    end

    def call(comments, org_repo, issue_number, config)
      plus_one_count = count_matches(comments, config)
      sha = get_last_commit_sha(org_repo, issue_number)

      if plus_one_count > config[:match_count]
        client.add_labels_to_an_issue(org_repo, issue_number, [config.ok_label])
        status_creator.success(org_repo, sha, config)
      else
        status_creator.pending(org_repo, sha, config)
      end

      "Found #{plus_one_count} +1s on ##{issue_number} of:#{org_repo} at:#{sha}"
    end

    private

    attr_reader :logger, :client, :status_creator

    def count_matches(comments, config)
      comments.count { |comment| any_match?(comment, config) }
    end

    def any_match?(comment, config)
      config[:review_matches].any? { |plus_one| comment[:body].match(plus_one) }
    end

    def get_last_commit_sha(org_repo, issue_number)
      client.pull_commits(org_repo, issue_number).last[:sha]
    end
  end
end
