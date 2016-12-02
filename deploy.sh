#!/bin/bash
set +e

MACHINE=quiqup
IMAGE=ianvaughan/pr-checker

docker-machine start $MACHINE
eval $(docker-machine env $MACHINE)

echo "* Building..."
docker build --tag $IMAGE .

echo "* Pushing..."
docker push $IMAGE
