# Use official Maven image to build the project
FROM maven:3.9.3-eclipse-temurin-17 AS build

# Set working directory inside container
WORKDIR /app

# Copy pom.xml and download dependencies
COPY sales/pom.xml .

# Download dependencies only (caching for faster rebuilds)
RUN mvn dependency:go-offline -B

# Copy the full project
COPY sales/src ./src

# Build the project
RUN mvn clean package -DskipTests

# --------------------------
# Use lightweight JDK image to run the app
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the jar from build stage
COPY --from=build /app/target/sales-0.0.1-SNAPSHOT.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
