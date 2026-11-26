# 1. Create a network for testing
docker network create postgres

# 2. Start the primary node
docker run -d \
  --name postgres-primary-0 \
  --network postgres \
  -v postgres_primary_data:/bitnami/postgresql \
  -e POSTGRESQL_POSTGRES_PASSWORD=adminpassword \
  -e POSTGRESQL_USERNAME=myuser \
  -e POSTGRESQL_PASSWORD=mypassword \
  -e POSTGRESQL_DATABASE=mydb \
  -e REPMGR_PASSWORD=repmgrpassword \
  -e REPMGR_PRIMARY_HOST=postgres-primary-0 \
  -e REPMGR_PRIMARY_PORT=5432 \
  -e REPMGR_PARTNER_NODES=postgres-primary-0,postgres-standby-1:5432 \
  -e REPMGR_NODE_NAME=postgres-primary-0 \
  -e REPMGR_NODE_NETWORK_NAME=postgres-primary-0 \
  -e REPMGR_PORT_NUMBER=5432 \
  devwikirepo/postgresql-repmgr:15

# 3. Start the standby node
docker run -d \
  --name postgres-standby-1 \
  --network postgres \
  -v postgres_standby_data:/bitnami/postgresql \
  -e POSTGRESQL_POSTGRES_PASSWORD=adminpassword \
  -e POSTGRESQL_USERNAME=myuser \
  -e POSTGRESQL_PASSWORD=mypassword \
  -e POSTGRESQL_DATABASE=mydb \
  -e REPMGR_PASSWORD=repmgrpassword \
  -e REPMGR_PRIMARY_HOST=postgres-primary-0 \
  -e REPMGR_PRIMARY_PORT=5432 \
  -e REPMGR_PARTNER_NODES=postgres-primary-0,postgres-standby-1:5432 \
  -e REPMGR_NODE_NAME=postgres-standby-1 \
  -e REPMGR_NODE_NETWORK_NAME=postgres-standby-1 \
  -e REPMGR_PORT_NUMBER=5432 \
  devwikirepo/postgresql-repmgr:15

# 4. Check the logs of each container in SHELL1 and SHELL2
docker logs -f postgres-primary-0
docker logs -f postgres-standby-1

# 5. Create a table and insert data on the primary node 
docker exec -it -e PGPASSWORD=mypassword postgres-primary-0 psql -U myuser -d mydb -c "CREATE TABLE sample (id SERIAL PRIMARY KEY, name VARCHAR(255));"
docker exec -it -e PGPASSWORD=mypassword postgres-primary-0 psql -U myuser -d mydb -c "INSERT INTO sample (name) VALUES ('John'), ('Jane'), ('Alice');"

# 6. Check that the data has been replicated to the standby node
docker exec -it -e PGPASSWORD=mypassword postgres-standby-1 psql -U myuser -d mydb -c "SELECT * FROM sample;"

# 7. Clean up
docker rm -f postgres-primary-0 postgres-standby-1
docker volume rm postgres_primary_data postgres_standby_data
docker network rm postgres
