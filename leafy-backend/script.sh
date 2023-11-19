#1. 이미지 빌드 및 푸시 easydocker/leafy/leafy-backend 경로에서 실행
docker build -t (개인레지스트리명)/leafy-backend:1.0.0 . --no-cache
docker push (개인레지스트리명)/leafy-backend:1.0.0 

#2. 컨테이너 실행 및 로그 확인
docker run -d -p 8080:8080 -e DB_URL=leafy-postgres --name leafy --network leafy-network (개인레지스트리명)/leafy-backend:1.0.0 
docker logs leafy-backend

#3. API 테스트
curl http://localhost:8080/api/v1/users
curl http://localhost:8080/api/v1/plant-logs/1