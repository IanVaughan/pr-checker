require 'yaml'
require 'active_support/hash_with_indifferent_access'

class ConfigFileLoader
  CONFIG_FILENAME = '.pr-checker.yml'.freeze
  attr_reader :config

  def initialize(client)
    @client = client
  end

  def load(org_repo, branch = nil)
    raw_file = client.read_file_from_repo(CONFIG_FILENAME, org_repo, branch)
    @config = parse_file(raw_file).symbolize_keys
  rescue RuntimeError => e
    { error: e.message }
  end

  private

  attr_reader :client

  def parse_file(file)
    file = JSON.parse(file).symbolize_keys if file.class == String
    content = file[:content]
    decode = Base64.decode64(content)
    convert = YAML.load(decode)
  end
end
