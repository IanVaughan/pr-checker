require 'gitlab'
require 'json'

module Gitlab
  class Access
    def initialize
      Gitlab.configure do |config|
        config.endpoint = ENV['GITLAB_API_ENDPOINT']
        config.private_token = ENV['GITLAB_API_PRIVATE_TOKEN']
      end
    end

    protected

    def response_to_array(response)
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
