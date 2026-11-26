# Use OpenJDK 11 & Gradle as the build image
FROM gradle:7.6.1-jdk11 AS build

# Create the working directory for the source code
WORKDIR /app

# Copy only the files needed to install the libraries
COPY build.gradle settings.gradle ./

RUN gradle dependencies --no-daemon

# Copy the source code from the host machine into the working directory
COPY . /app

# Run the Gradle build to create the JAR file
RUN gradle clean build --no-daemon

# Use OpenJDK 11 JRE-slim as the runtime image
# The openjdk image was removed from Docker Hub, so it was replaced with eclipse-temurin, the same Java 11 JRE (2026-11)
FROM eclipse-temurin:11-jre

# Create the working directory for running the application
WORKDIR /app

# Copy the JAR file built in the build image into the runtime image
COPY --from=build /app/build/libs/*.jar /app/leafy.jar

EXPOSE 8080 
ENTRYPOINT ["java"] 
CMD ["-jar", "leafy.jar"]
