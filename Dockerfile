# Stage 1: Build the project
FROM maven:3.9.3-eclipse-temurin-17 AS build
WORKDIR /app

# Copy the pom.xml from the nested folder
COPY sales/sales/pom.xml ./pom.xml

# Download dependencies (caching)
RUN mvn dependency:go-offline -B

# Copy the source code from nested folder
COPY sales/sales/src ./src

# Build the project
RUN mvn clean package -DskipTests

# Stage 2: Run the project
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copy the jar built in the first stage
COPY --from=build /app/target/sales-0.0.1-SNAPSHOT.jar ./app.jar

# Expose Spring Boot default port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
