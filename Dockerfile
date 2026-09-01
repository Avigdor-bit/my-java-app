FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy the JAR file
COPY target/*.jar app.jar

# Expose port (if web app)
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
