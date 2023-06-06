# 빌드 스테이지
FROM node:14 AS build

WORKDIR /app

# 소스코드 복사
COPY . /app

# 라이브러리 설치
RUN npm ci
# 소스코드 빌드
RUN npm run build

# 프로덕션 스테이지
FROM nginx:1.21.4-alpine 

# 빌드 스테이지에서 생성된 빌드 결과물을 복사
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
