# Stage 1: Build the Spring Boot app
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy only the module containing pom.xml
COPY "sales/sales/pom.xml" /app/pom.xml

# Download dependencies
RUN mvn -e -X dependency:go-offline

# Copy full source code
COPY "sales/sales" /app

# Package the Spring Boot application
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy JAR from build stage
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
