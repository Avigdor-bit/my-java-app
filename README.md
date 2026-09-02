I'll help you create a complete "My Java App Server" configuration step by step using Bash. This will include setting up Docker, Java, and a web application server.

## Complete Bash Script for "My Java App Server"

### Step 1: Create the Main Setup Script

```bash
#!/bin/bash

# My Java App Server - Complete Setup Script
# Version: 2.0.0

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration Variables
APP_NAME="my-java-app"
APP_VERSION="2.0.0"
DOCKER_IMAGE="${APP_NAME}:${APP_VERSION}"
CONTAINER_NAME="${APP_NAME}-container"
HOST_PORT=8080
CONTAINER_PORT=8080

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  My Java App Server Setup v${APP_VERSION}${NC}"
echo -e "${BLUE}========================================${NC}"

# Step 2: Check Prerequisites
echo -e "\n${YELLOW}[Step 1] Checking prerequisites...${NC}"

check_prerequisite() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}✗ $1 is not installed${NC}"
        echo -e "${YELLOW}Installing $1...${NC}"
        return 1
    else
        echo -e "${GREEN}✓ $1 is installed${NC}"
        return 0
    fi
}

# Check Docker
if ! check_prerequisite docker; then
    echo -e "${YELLOW}Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo -e "${GREEN}✓ Docker installed successfully${NC}"
fi

# Check Java
if ! check_prerequisite java; then
    echo -e "${YELLOW}Installing Java 17...${NC}"
    sudo apt-get update
    sudo apt-get install -y openjdk-17-jdk
    echo -e "${GREEN}✓ Java 17 installed successfully${NC}"
fi

# Check Maven
if ! check_prerequisite mvn; then
    echo -e "${YELLOW}Installing Maven...${NC}"
    sudo apt-get install -y maven
    echo -e "${GREEN}✓ Maven installed successfully${NC}"
fi

# Step 3: Create Project Structure
echo -e "\n${YELLOW}[Step 2] Creating project structure...${NC}"

PROJECT_DIR="${HOME}/${APP_NAME}"
mkdir -p ${PROJECT_DIR}/{src/main/java/com/example,src/main/resources,src/test/java}

cd ${PROJECT_DIR}

# Step 4: Create Dockerfile
echo -e "\n${YELLOW}[Step 3] Creating Dockerfile...${NC}"

cat > Dockerfile << 'EOF'
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy Maven wrapper and pom.xml
COPY pom.xml .
COPY src ./src

# Build the application
RUN apt-get update && apt-get install -y maven && \
    mvn clean package -DskipTests && \
    mv target/*.jar app.jar && \
    apt-get remove -y maven && apt-get autoremove -y

# Create application user
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
