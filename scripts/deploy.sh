#!/bin/bash
set +e

MACHINE=quiqup
IMAGE=ianvaughan/pr-checker
BRANCH=$(git rev-parse --abbrev-ref HEAD)

docker-machine start $MACHINE
eval $(docker-machine env $MACHINE)

echo "This branch:$BRANCH"

docker-machine env $HOST

echo "* Building..."
docker build --tag $IMAGE:$BRANCH .

echo "* Pushing..."
docker push $IMAGE:$BRANCH
echo "Pushed $IMAGE:$BRANCH"
