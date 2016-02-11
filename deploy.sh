docker build -t pr-checker .
docker stop pr-checker
docker rm pr-checker
docker run -d --env-file .env -p 4444:4567 --name pr-checker pr-checker
