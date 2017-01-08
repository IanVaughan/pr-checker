#!/bin/bash
set +e

MACHINE=quiqup
IMAGE=ianvaughan/pr-checker
BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_SHA=$(git rev-parse --short HEAD)
TAG=${BRANCH}_${GIT_SHA}

echo "* On branch:$BRANCH, sha:$GIT_SHA, running image with:$TAG"

docker-machine start $MACHINE
eval $(docker-machine env $MACHINE)

docker run -it --rm --env-file .env -p 80:80 $IMAGE:$TAG

# curl http://192.168.99.101:80/ping
