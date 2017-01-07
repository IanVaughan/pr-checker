#!/bin/bash
set +e

MACHINE=quiqup
IMAGE=ianvaughan/pr-checker
BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "This branch:$BRANCH"

docker-machine start $MACHINE
docker-machine env $MACHINE
eval $(docker-machine env $MACHINE)

echo "* Building..."
docker build --tag $IMAGE:$BRANCH .

echo "* Pushing..."
docker push $IMAGE:$BRANCH
echo "Pushed $IMAGE:$BRANCH"
