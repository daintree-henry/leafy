# Build and push the Docker image
docker build -t {TYPE_YOUR_REPOSITORY}/leafy-front:1.0.0 . --no-cache
docker push {TYPE_YOUR_REPOSITORY}/leafy-front:1.0.0

# Create the container (on Windows, use cmd or PowerShell)
docker run -d -p 80:80 --network leafy-network --name leafy-front {TYPE_YOUR_REPOSITORY}/leafy-front:1.0.0

# Check the logs and open http://localhost
docker logs -f leafy-front
