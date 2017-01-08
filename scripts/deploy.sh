#!/bin/bash
set +e

MACHINE=quiqup
IMAGE=ianvaughan/pr-checker
BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_SHA=$(git rev-parse --short HEAD)
IMAGE_TAG=${BRANCH}_${GIT_SHA}

echo "* On branch:$BRANCH, sha:$GIT_SHA, tagging image with:$IMAGE_TAG"

docker-machine start $MACHINE
eval $(docker-machine env $MACHINE)

echo "* Building image..."
docker build --tag $IMAGE:$IMAGE_TAG .

echo "* Pushing..."
docker push $IMAGE:$IMAGE_TAG
echo "Pushed $IMAGE:$IMAGE_TAG"
