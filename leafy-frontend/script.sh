# 1. Build and push the image (run from easydocker/part5/leafy)
docker build -t (개인레지스트리명)/leafy-frontend:1.0.0 . --no-cache
docker push (개인레지스트리명)/leafy-frontend:1.0.0 

# 2. Run the container, check the logs, and open localhost
docker run -d -p 80:80 --name leafy-front --network leafy-network (개인레지스트리명)/leafy-frontend:1.0.0 
docker logs -f leafy-front