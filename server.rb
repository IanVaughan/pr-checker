require 'sinatra'
require 'json'
require 'octokit'
require 'dotenv'
require 'pry'

Dotenv.load
PLUS_ONE_TEXT = ENV["PR_CHECKER_PLUS_ONE_TEXT"]
PLUS_ONE_TEXT_REGEXP = Regexp.quote PLUS_ONE_TEXT
OK_LABEL = ENV["PR_CHECKER_OK_LABEL"]
ACCESS_TOKEN = ENV["PR_CHECKER_ACCESS_TOKEN"]
CONTEXT = ENV["PR_CHECKER_CONTEXT"]
INFO = ENV["PR_CHECKER_INFO"]

puts "Read from env:"
puts "PLUS_ONE_TEXT: #{PLUS_ONE_TEXT}"
puts "OK_LABEL: #{OK_LABEL}"
puts "ACCESS_TOKEN: #{ACCESS_TOKEN}"
puts "CONTEXT: #{CONTEXT}"
puts "INFO: #{INFO}"

client = Octokit::Client.new(access_token: ACCESS_TOKEN)
begin
  client.user # assert access is working otherwise will raise
rescue Octokit::Unauthorized
  puts "ACCESS_TOKEN does not work! I don't have access. #{ACCESS_TOKEN}"
  exit
end

set :bind, '0.0.0.0' # Required for Docker

get "/ping" do
  "pong"
end

get "/github" do
  # refresh access
end

post '/payload' do
  push = JSON.parse(request.body.read)
  puts "payload:#{push}"
  return unless push.key?("issue")
  return unless push["issue"].key?("number")
  issue_number = push["issue"]["number"]
  repo = push["repository"]["full_name"]
  puts "repo:#{repo}, issue_number:#{issue_number}"

  begin
    comments = client.issue_comments(repo, issue_number)
  rescue Octokit::NotFound => e
    puts "ERROR: cannot find issue. #{e}"
    return
  end

  plus_one_count = comments.count { |c| c[:body].match PLUS_ONE_TEXT_REGEXP }

  puts "repo:#{repo}, issue_number:#{issue_number}, count:#{plus_one_count}"

  commits = client.pull_commits repo, issue_number
  commit_sha = commits.last[:sha]
  info = { context: CONTEXT, infomation: INFO }
  puts "commit:#{commit_sha}, info:#{info}"

  if plus_one_count > 1
    client.add_labels_to_an_issue(repo, issue_number, [OK_LABEL])
    client.create_status(repo, commit_sha, 'success', info)
  else
    client.remove_label(repo, issue_number, OK_LABEL)
    client.create_status(repo, commit_sha, 'pending', info)
  end
  puts "end..."
end
