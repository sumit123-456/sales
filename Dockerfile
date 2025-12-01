# ---------- BUILD STAGE ----------
FROM maven:3.8.5-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml (path contains a space → must be quoted)
COPY salesProject 1/ pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy full project source
COPY salesProject 1/ .

# Package the Spring Boot app
RUN mvn package -DskipTests -B


# ---------- RUNTIME STAGE ----------
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy jar from previous stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
