# My Java App

## 🚀 Run with Docker

\`\`\`bash
# Build the JAR
mvn clean package

# Build Docker image
docker build -t my-java-app .

# Run the container
docker run -p 8080:8080 my-java-app
\`\`\`

## 📦 Technologies

- Java 17
- Maven
- Docker

## 🔧 Local Development

\`\`\`bash
mvn clean install
java -jar target/my-java-app-1.0-SNAPSHOT.jar
\`\`\`
