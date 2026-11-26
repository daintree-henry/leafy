docker network create leafy-network

# Build and push the Docker image
docker build -t {TYPE_YOUR_REPOSITORY}/leafy-postgres:1.0.0 . --no-cache
docker push {TYPE_YOUR_REPOSITORY}/leafy-postgres:1.0.0

# Create the container 
docker run -d --name leafy-postgres --network leafy-network {TYPE_YOUR_REPOSITORY}/leafy-postgres:1.0.0

# Check the logs
docker logs -f leafy-postgres

# Run a command in the container
docker exec -it leafy-postgres su postgres bash -c "psql --username=myuser --dbname=mydb"

# Query the data
$ mydb=# SELECT * FROM users;
$ mydb=# SELECT * FROM plants;
$ mydb=# SELECT * FROM user_plants;
$ mydb=# SELECT * FROM plant_logs;

