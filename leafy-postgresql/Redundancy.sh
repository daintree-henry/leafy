#1. 테스트용 네트워크 생성
docker network create postgres

#2. 프라이머리 노드 실행
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
  bitnami/postgresql-repmgr:15

#3. 스탠바이 노드 실행
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
  bitnami/postgresql-repmgr:15

# 4. SHELL1, SHELL2 각 컨테이너의 로그 확인
docker logs -f postgres-primary-0
docker logs -f postgres-standby-1

# 5. 프라이머리 노드에 테이블 생성 및 데이터 삽입 
docker exec -it -e PGPASSWORD=mypassword postgres-primary-0 psql -U myuser -d mydb -c "CREATE TABLE sample (id SERIAL PRIMARY KEY, name VARCHAR(255));"
docker exec -it -e PGPASSWORD=mypassword postgres-primary-0 psql -U myuser -d mydb -c "INSERT INTO sample (name) VALUES ('John'), ('Jane'), ('Alice');"

#6. 스탠바이 노드에 데이터가 동기화되어 있는지 확인
docker exec -it -e PGPASSWORD=mypassword postgres-standby-1 psql -U myuser -d mydb -c "SELECT * FROM sample;"

#7. 환경 정리
docker rm -f postgres-primary-0 postgres-standby-1
docker volume rm postgres_primary_data postgres_standby_data
docker network rm postgres
