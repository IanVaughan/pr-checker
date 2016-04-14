echo "* Building..."
docker build --tag pr-checker-image .
echo "* Stopping current instance..."
docker stop pr-checker-container
echo "* Removing old instance..."
docker rm pr-checker-container
echo "* Starting new instance..."
docker run -d --env-file .env -p 4444:4567 --name pr-checker-container pr-checker-image
echo "* Showing you the logs..."
docker logs -f pr-checker-container
