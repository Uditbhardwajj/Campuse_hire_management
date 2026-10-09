# ==========================================================
# Dockerfile for 24/7 Cloud Deployment (Render / Railway)
# ==========================================================

# Stage 1: Build the WAR using Maven and Java 17
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the WAR package
RUN mvn clean package -DskipTests

# Stage 2: Deploy to Apache Tomcat 10.1
FROM tomcat:10.1-jdk17-temurin
WORKDIR /usr/local/tomcat

# Remove default Tomcat webapps
RUN rm -rf webapps/*

# Deploy placement.war as ROOT.war (accessible directly at the domain root /)
COPY --from=build /app/target/placement.war webapps/ROOT.war

# Ensure MySQL Connector is in Tomcat library
COPY src/main/webapp/WEB-INF/lib/mysql-connector-j.jar lib/

EXPOSE 8080
CMD ["catalina.sh", "run"]
