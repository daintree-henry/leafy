docker network create leafy-network

#도커 이미지 빌드 및 푸시
docker build -t {TYPE_YOUR_REPOSITORY}/leafy-postgres:1.0.0 . --no-cache
docker push {TYPE_YOUR_REPOSITORY}/leafy-postgres:1.0.0

# 컨테이너 생성 
docker run -d --name leafy-postgres --network leafy-network {TYPE_YOUR_REPOSITORY}/leafy-postgres:1.0.0

# 로그 확인
docker logs -f leafy-postgres

# 컨테이너 명령어 실행
docker exec -it leafy-postgres su postgres bash -c "psql --username=myuser --dbname=mydb"

# 데이터 조회
$ mydb=# SELECT * FROM users;
$ mydb=# SELECT * FROM plants;
$ mydb=# SELECT * FROM user_plants;
$ mydb=# SELECT * FROM plant_logs;

