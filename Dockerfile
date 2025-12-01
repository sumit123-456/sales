# Stage 1: Build the project
FROM maven:3.9.3-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml and download dependencies
COPY sales/sales/pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY sales/sales/. .

# Build jar
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copy the built jar from build stage
COPY --from=build /app/target/sales-0.0.1-SNAPSHOT.jar ./app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
