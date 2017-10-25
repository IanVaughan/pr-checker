# PR Checker [![Build Status](https://travis-ci.org/IanVaughan/pr-checker.svg?branch=master)](https://travis-ci.org/IanVaughan/pr-checker)

Checks for key comments on pull requests and updates them with statues and labels.

If two `:+1:`s are seen on a PR, it adds the label `+d2` and sets the status on the last commit as `success`.

All options are configurable via ENV (using Dotenv), see `.env.example`

A config file can be checked into the root at the repo `.pr-checker.yml`

## Auto Assign

If the config file has the assignees section, it will assign the PR to those people when opened.

Once you have given a +1, it will automatically remove you from the Assignees list.

The names must be as per the GitHub profile name, eg `https://github.com/<name here>`

```yaml
assignees:
  - GithubHandle
  - GitHandle2
```

## Dev

Setup

    cp .env.example .env
    # edit as required

Boot

    rackup

Setup tunnel to internet to test from GitHub

    ngrok 4567 # v1.7
    ngrok http 4567 # >v2.0

## Setup GitHub

Goto: `https://github.com/<user>/<repo>/settings/hooks/`

Under "Webhooks", select "Add Webhook"

Set "Payload URL" to "https://yourhost.com:port/payload"

Tick: Issue comment: Issue commented on.


## Access token

You need a Personal Access token from github : https://github.com/settings/tokens




https://github.com/anlek/mongify/issues/130
https://github.com/stripe-contrib/pagerbot/issues/46

docker run --name lab-stats-mongo -v $PWD/data:/data/db -p 27017:27017 -d mongo:3.2

docker run --name lab-stats-app --link lab-stats-mongo:mongo -d application-that-uses-mongo
docker run -it --link lab-stats-mongo:mongo --rm mongo sh -c 'exec mongo "$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/test"'

alias pgup="docker run --name postgres -v ~/pgdata:/var/lib/postgresql/data -d -p 5432:5432 --restart always mdillon/postgis -c log_statement=all"

* `sidekiq -r ./lib/initializers/sidekiq.rb` For sidekiq server
* `rackup config.ru` For Sidekiq web
* `pry -r ./lib/initializers/sidekiq.rb`

[1] pry(main)> Workers::Projects.perform_async
Workers::MergeRequests.perform_async(20)
