#!/bin/bash
set +e

MACHINE=quiqup
IMAGE=ianvaughan/pr-checker
BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_SHA=$(git rev-parse --short HEAD)
TAG=${BRANCH}_${GIT_SHA}

echo "* On branch:$BRANCH, sha:$GIT_SHA, pushing image with:$TAG"

docker push $IMAGE:$TAG
echo "Pushed $IMAGE:$TAG"
