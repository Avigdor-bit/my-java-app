#!/bin/bash

# My Java App Server Startup Script
set -e

APP_NAME="my-java-app"
CONTAINER_NAME="${APP_NAME}-container"
HOST_PORT=8080

echo "Starting My Java App Server..."

# Check if container exists and remove it
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Removing existing container..."
    docker stop ${CONTAINER_NAME} 2>/dev/null || true
    docker rm ${CONTAINER_NAME} 2>/dev/null || true
fi

# Build and run with Docker Compose
docker-compose up -d --build

# Wait for health check
echo "Waiting for application to start..."
for i in {1..30}; do
    if curl -s http://localhost:${HOST_PORT}/api/health > /dev/null; then
        echo -e "\n✅ Application is running!"
        echo "📊 Stats available at: http://localhost:${HOST_PORT}/api/info"
        echo "🏥 Health check at: http://localhost:${HOST_PORT}/api/health"
        echo "📦 Version info: http://localhost:${HOST_PORT}/api/version"
        exit 0
    fi
    echo -n "."
    sleep 2
done

echo -e "\n❌ Application failed to start in time"
docker logs ${CONTAINER_NAME} --tail 50
exit 1
