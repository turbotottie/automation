#!/bin/bash

echo "Starting update process..."

# Check if docker is running
if ! docker info >/dev/null 2>&1; then
    echo "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Pull latest images
echo "Pulling latest Docker images..."
docker compose pull nocodb n8n postgres redis

# Stop current containers
echo "Stopping current containers..."
docker compose down

# Start updated containers
echo "Starting updated containers with new versions..."
docker compose up -d

# Wait for services to be healthy
echo "Waiting for services to be healthy..."
sleep 10

# Check if services are running
if docker compose ps | grep -q "Up"; then
    echo "Services updated and running successfully!"
    
    # Display current versions
    echo -e "\nCurrent versions:"
    echo "NocoDB: $(docker compose exec nocodb node -e 'console.log(require("./package.json").version)' 2>/dev/null)"
    echo "n8n: $(docker compose exec n8n n8n --version 2>/dev/null)"
else
    echo "Error: Some services failed to start. Please check docker compose logs."
    exit 1
fi
