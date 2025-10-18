#!/usr/bin/env bash
set -e
echo "Starting local Postgres..."
docker-compose -f docker/docker-compose.yml up -d
echo "Building monolith..."
cd monolith
mvn clean package -DskipTests
echo "Run jar..."
java -jar target/monolith-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev &



