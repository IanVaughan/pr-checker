require 'gitlab'

GITLAB_API_ENDPOINT = ENV['GITLAB_API_ENDPOINT']
GITLAB_API_PRIVATE_TOKEN = ENV['GITLAB_API_PRIVATE_TOKEN']

module Gitlab
  class Access
    def initialize
      Gitlab.configure do |config|
        config.endpoint = GITLAB_API_ENDPOINT
        config.private_token = GITLAB_API_PRIVATE_TOKEN
      end
    end

    protected

    def response_to_array(response)
      return [] if response.empty?
      response.auto_paginate.map { |item| response_to_hash(item) }
    end

    def response_to_hash(response)
      symbolize_keys(response.to_hash)
    end

    def symbolize_keys(hash)
      hash.inject({}) { |memo,(k,v)| memo[k.to_sym] = v; memo }
    end
  end
end
