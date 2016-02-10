# PR Checker

Checks for key comments on pull requests and updates them with statues and labels.

If two `:+1:`s are seen on a PR, it adds the label `+d2` and sets the status on the last commit as `success`.

All options are configurable via ENV (using Dotenv), see `.env.example`


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

    ID=$(docker run -d --env-file .env -p 4444:4567 --name pr-checker pr-checker)
    echo $ID

Other things 

    docker logs -f pr-checker
    docker stop pr-checker
    docker rm pr-chcker



test
