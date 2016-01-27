require 'sinatra'
require 'json'
require 'octokit'

REPO = "QuiqUpLTD/QuiqupAPI"
PLUS_ONE_TEXT = /:\+1:/
OK_LABEL = '+2d'

client = Octokit::Client.new(:access_token => ENV.fetch("ACCESS_TOKEN"))
client.user # assets access is working otherwise will raise

# Required for Docker
set :bind, '0.0.0.0'

get "/ping" do
  "pong"
end

post '/payload' do
  push = JSON.parse(request.body.read)
  return unless push.key?("issue")
  return unless push["issue"].key?("number")
  issue_number = push["issue"]["number"]

  comments = client.issue_comments(REPO, issue_number)
  plus_one_count = comments.count { |c| c[:body].match PLUS_ONE_TEXT }

  puts "Received #{issue_number}:#{plus_one_count}"

  commits = client.pull_commits REPO, issue_number
  commit_sha = commits.last[:sha]
  info = {
    context: "2+1s",
    infomation: "You have 2+1s and are go for merge!"
  }

  puts commit_sha
  puts info

  if plus_one_count > 1
    client.add_labels_to_an_issue(REPO, issue_number, [OK_LABEL]) 

    client.create_status(REPO, commit_sha, 'success', info)
  else
    client.create_status(REPO, commit_sha, 'pending', info)
  end
end
