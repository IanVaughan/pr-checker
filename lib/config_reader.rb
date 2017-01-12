require 'yaml'
require 'active_support/hash_with_indifferent_access'
require 'ostruct'

class ConfigReader
  include Logging
  CONFIG_FILENAME = '.pr-checker.yml'

  def initialize(client)
    @client = client
  end

  def call(org_repo, branch)
    raw_file = read_config_file_from_repo(org_repo, branch)
    OpenStruct.new parse_file(raw_file)
    # @config = parse_file(raw_file).symbolize_keys
  end

  private

  attr_reader :client

  def read_config_file_from_repo(org_repo, branch = nil)
    # client.get "/repos/#{org_repo}/contents/#{CONFIG_FILENAME}?ref=#{branch}"
    # client.contents org_repo, path: "#{CONFIG_FILENAME}?ref=#{branch}"
    # client.contents org_repo, path: CONFIG_FILENAME
    client.contents org_repo, path: CONFIG_FILENAME + (branch ? "?ref=#{branch}" : '')
  rescue Octokit::NotFound
    message = "Could not find file:#{CONFIG_FILENAME} in:#{org_repo}"
    logger.error message
    raise message
  end

  def parse_file(file)
    YAML.load(Base64.decode64(file[:content])).deep_symbolize_keys
    # file = JSON.parse(file).symbolize_keys if file.class == String
    # content = file[:content]
    # decode = Base64.decode64(content)
    # convert = YAML.load(decode)
  end
end
