# PR Checker

Checks for key comments on pull requests and updates them with statues and labels.

If two `:+1:`s are seen on a PR, it adds the label `+d2` and sets the status on the last commit as `success`.

All options are configurable via ENV (using Dotenv), see `.env.example`

A config file can be checked into the root at the repo `.pr-checker.yml`

## Auto Assign

If the config file has the assignees section, it will assign the PR to those people when opened.

Once you have given a +1, it will automatically remove you from the Assignees list.

The names must be as per the GitHub profile name, eg `https://github.com/<name here>`

## Dev

Setup

    cp .env.example .env
    # edit as required

Boot

    ruby server.rb

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


## Docker

Local usage

    docker-machine create --driver virtualbox pr-checker
    docker-machine env pr-checker # Just for info
    eval "$(docker-machine env pr-checker)" # Repeat this for any new shells

Build

    docker build -t pr-checker .

Run test

    docker run -i -t --rm --env-file .env -p 4444:4567 pr-checker

Run real

    docker run -d --env-file .env -p 4444:4567 --name pr-checker pr-checker

Other docker commands :

    docker logs -f pr-checker
    docker stop pr-checker
    docker rm pr-chcker



Notts1

    dm create --driver generic --generic-ip-address 78.129.181.12 --generic-ssh-port 10022 --generic-ssh-user www-deploy notts1
    dm create --driver generic --generic-ip-address 78.129.181.9 --generic-ssh-port 10022 --generic-ssh-user www-deploy notts2
    dm env notts1
    eval "$(docker-machine env notts1)"

check

    curl http://notts1.quiqup.com:4444/ping


Setup

    https://github.com/QuiqUpLTD/QuiqupAPI/settings/hooks/7090796


Payload URL:

    http://notts1.quiqup.com:4444/payload

