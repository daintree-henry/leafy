# Build and push the Docker image
docker build -t {TYPE_YOUR_REPOSITORY}/leafy-backend:1.0.0 . --no-cache
docker push {TYPE_YOUR_REPOSITORY}/leafy-backend:1.0.0 

# Create the container (on Windows, use cmd or PowerShell)
docker run -d -p 8080:8080 -e DB_URL=leafy-postgres --network leafy-network --name leafy {TYPE_YOUR_REPOSITORY}/leafy-backend:1.0.0

# Check the logs
docker logs -f leafy
