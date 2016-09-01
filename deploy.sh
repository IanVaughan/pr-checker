#!/bin/bash
set -e

HOST=notts2
IMAGE=pr-checker-image
CONTAINER=pr-checker-container

eval $(docker-machine env $HOST)

echo "* Building..."
docker build --tag $IMAGE .
echo "* Stopping current instance..."
docker stop $CONTAINER
echo "* Removing old instance..."
docker rm $CONTAINER
echo "* Starting new instance..."
docker run -d --env-file .env -p 4444:4567 --restart=always --name $CONTAINER $IMAGE
echo "* Showing you the logs..."
docker logs -f $CONTAINER
