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

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the dist folder built in the build image into the nginx image
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
