require 'yaml'
require 'active_support/hash_with_indifferent_access'

class ConfigFileLoader
  CONFIG_FILENAME = '.pr-checker.yml'
  attr_reader :config

  def initialize(client)
    @client = client
  end

  def get(org_repo, branch = nil)
    raw_file = read_config_file_from_repo(org_repo, branch)
    @config = parse_file(raw_file).symbolize_keys
  rescue RuntimeError => e
    { error: e.message }
  end

  private

  attr_reader :client

  def read_config_file_from_repo(org_repo, branch = nil)
    client.contents org_repo, path: CONFIG_FILENAME + (branch ? "?ref=#{branch}" : '')
  rescue Octokit::NotFound
    message = "Could not find file:#{CONFIG_FILENAME} in:#{org_repo}"
    raise message
  end

  def parse_file(file)
    content = file[:content]
    decode = Base64.decode64(content)
    convert = YAML.load(decode)
  end
end
