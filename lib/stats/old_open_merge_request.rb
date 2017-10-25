module Stats
  class OldOpenMergeRequest
    OPENED = 'opened'.freeze
    OLD_TIME = 86400 * 7

    def call(merge_request)
      next unless merge_request[:state] == OPENED

      merge_request[:web_url] if Time.parse(merge_request[:created_at]) < Time.at(Time.now.to_i - OLD_TIME)
    end
  end
end
