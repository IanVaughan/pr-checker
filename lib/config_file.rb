require 'yaml'
require 'active_support/hash_with_indifferent_access'

class ConfigFile
  CONFIG_FILENAME = '.pr_checker.yml'

  def initialize(client, org_repo)
    @client = client
    @org_repo = org_repo
  end

  def call
    raw_file = read_config_file_from_repo

    if raw_file.nil?
      message = "Could not find file:#{CONFIG_FILENAME} in:#{org_repo}"
      puts message
      { error: message }
    else
      { ok: parse_file(raw_file) }
    end
  end

  private

  attr_reader :client, :org_repo

  def read_config_file_from_repo
    client.contents org_repo, path: CONFIG_FILENAME
  rescue Octokit::NotFound
  end

  def parse_file(file)
    YAML.load(Base64.decode64(file[:content])).deep_symbolize_keys
  end
end
