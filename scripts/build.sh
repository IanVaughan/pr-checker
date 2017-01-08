#!/bin/bash
set +e

MACHINE=quiqup
IMAGE=ianvaughan/pr-checker
BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_SHA=$(git rev-parse --short HEAD)
TAG=${BRANCH}_${GIT_SHA}

echo "* On branch:$BRANCH, sha:$GIT_SHA, tagging image with:$TAG"

docker-machine start $MACHINE
eval $(docker-machine env $MACHINE)
docker-machine env $MACHINE

echo "* Building image..."
docker build --tag $IMAGE:$TAG .
