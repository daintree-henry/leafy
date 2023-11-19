# 1. 이미지 빌드 및 푸시 (easydocker/part5/leafy 경로에서 실행)
docker build -t (개인레지스트리명)/leafy-frontend:1.0.0 . --no-cache
docker push (개인레지스트리명)/leafy-frontend:1.0.0 

# 2. 컨테이너 실행 및 로그 확인, localhost 접속 테스트
docker run -d -p 80:80 --name leafy-front --network leafy-network (개인레지스트리명)/leafy-frontend:1.0.0 
docker logs -f leafy-front