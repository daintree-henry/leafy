# Use node:14 as the build image 
FROM node:14 AS build

WORKDIR /app

# Copy the source code from the build context into the working directory, install the libraries, and build
COPY . /app
RUN npm ci
RUN npm run build

# Use nginx 1.21.4 as the runtime image and grant permissions on /usr/share/nginx/html
FROM nginx:1.21.4-alpine

# Copy the dist folder built in the build image into the nginx image
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
