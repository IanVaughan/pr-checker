require 'yaml'
require 'active_support/hash_with_indifferent_access'
require 'ostruct'

class ConfigFileLoader
  CONFIG_FILENAME = '.pr-checker.yml'

  def initialize(client)
    @client = client
  end

  def get(org_repo)
    raw_file = read_config_file_from_repo(org_repo)
    OpenStruct.new parse_file(raw_file)
  end

  private

  attr_reader :client

  def read_config_file_from_repo(org_repo)
    # client.get "/repos/IanVaughan/pr-checker/contents/.pr_checker.yml?ref=all-config-in-repo"
    # client.get "/repos/#{org_repo}/contents/#{CONFIG_FILENAME}"
    # client.contents 'IanVaughan/pr-checker', path: "#{CONFIG_FILENAME}?ref=all-config-in-repo"
    # client.contents org_repo, path: "#{CONFIG_FILENAME}?ref=all-config-in-repo"
    client.contents 'IanVaughan/pr-checker', path: "#{CONFIG_FILENAME}?ref=all-config-in-repo"
    # client.contents org_repo, path: CONFIG_FILENAME
  rescue Octokit::NotFound
    message = "Could not find file:#{CONFIG_FILENAME} in:#{org_repo}"
    # logger.error message
    raise message
  end

  def parse_file(file)
    YAML.load(Base64.decode64(file[:content])).deep_symbolize_keys
  end
end
