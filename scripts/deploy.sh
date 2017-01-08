#!/bin/bash
set +e

MACHINE=quiqup
IMAGE=ianvaughan/pr-checker
BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "* Pushing..."
docker push $IMAGE:$BRANCH
echo "Pushed $IMAGE:$BRANCH"
