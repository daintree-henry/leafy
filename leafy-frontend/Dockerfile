# Use node:14 as the build image 
FROM node:14 AS build

WORKDIR /app

# Copy only the files needed to install the libraries
COPY package.json .
COPY package-lock.json .

# Install the libraries
RUN npm ci

# Copy the source code
COPY . /app

# Build the source code
RUN npm run build

# Production stage
FROM nginx:1.21.4-alpine 
COPY nginx.conf /etc/nginx/conf.d/default.conf.template
ENV BACKEND_HOST leafy
ENV BACKEND_PORT 8080

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Copy the dist folder built in the build image into the nginx image
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
