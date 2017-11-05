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

## Development

Setup

    cp .env.example .env
    # edit as required

Standalone :

* `docker run --name lab-stats-mongo -v $PWD/data:/data/db -p 27017:27017 -d mongo:3.2`
  * `docker start lab-stats-mongo`
* `sidekiq -r ./environment.rb` - Start sidekiq server
* `rackup`                      - Start Web / Sidekiq web http://localhost:9292/sidekiq
* `pry -r ./environment.rb`     - For ruby console

Docker compose

* `docker-compose up`
* `docker-compose exec sidekiq pry -r ./environment.rb`

Kick off refresh

* `curl -i -X POST localhost:9292/gitlab/refresh -d ''`

Setup tunnel to internet to test from GitHub

    ngrok 4567 # v1.7
    ngrok http 4567 # >v2.0



RACK_ENV=development rake db:reset
rake db:create    # Create the database
rake db:drop      # Drop the database
rake db:migrate   # Migrate the database
rake db:reset     # Reset the database
rake db:schema    # Create a db/schema.rb file that is portable against any DB supported by AR
a # Generate migration


## Setup GitHub

Goto: `https://github.com/<user>/<repo>/settings/hooks/`

Under "Webhooks", select "Add Webhook"

Set "Payload URL" to "https://yourhost.com:port/payload"

Tick: Issue comment: Issue commented on.

## Access token

You need a Personal Access token from github : https://github.com/settings/tokens
