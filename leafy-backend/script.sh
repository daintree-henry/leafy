# 1. Build and push the image (run from easydocker/leafy/leafy-backend)
docker build -t (개인레지스트리명)/leafy-backend:1.0.0 . --no-cache
docker push (개인레지스트리명)/leafy-backend:1.0.0 

# 2. Run the container and check the logs
docker run -d -p 8080:8080 -e DB_URL=leafy-postgres --name leafy --network leafy-network (개인레지스트리명)/leafy-backend:1.0.0 
docker logs leafy-backend

# 3. Test the API
curl http://localhost:8080/api/v1/users
curl http://localhost:8080/api/v1/plant-logs/1