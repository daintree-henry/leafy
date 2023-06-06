#도커 이미지 빌드 및 푸시
docker build -t {TYPE_YOUR_REPOSITORY}/leafy-front:1.0.0 . --no-cache
docker push {TYPE_YOUR_REPOSITORY}/leafy-front:1.0.0

# 컨테이너 생성 (윈도우 cmd or Powershell 사용)
docker run -d -p 80:80 --network leafy-network --name leafy-front {TYPE_YOUR_REPOSITORY}/leafy-front:1.0.0

# 로그 확인 및 http://localhost 접속
docker logs -f leafy-front
