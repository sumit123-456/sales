# ---------- BUILD STAGE ----------
FROM maven:3.8.5-eclipse-temurin-17 AS build

WORKDIR /app

# Copy the POM file
COPY "salesProject 1/sales/sales/pom.xml" ./pom.xml

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy full project source
COPY "salesProject 1/sales/sales/" .

# Build the jar
RUN mvn package -DskipTests -B


# ---------- RUNTIME STAGE ----------
FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
