# Stage 1: Build the project
FROM maven:3.9.3-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml (relative to build context)
COPY sales/sales/pom.xml ./pom.xml

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy all source code
COPY sales/sales/src ./src

# Build the project
RUN mvn clean package -DskipTests

# Stage 2: Run the app
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copy built jar
COPY --from=build /app/target/sales-0.0.1-SNAPSHOT.jar ./app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
