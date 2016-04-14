docker build --tag pr-checker-image .
docker stop pr-checker-container
docker rm pr-checker-container
docker run -d --env-file .env -p 4444:4567 --name pr-checker-container pr-checker-image
