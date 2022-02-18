#!/bin/bash

set -v

echo "Stopping "
docker-compose down --rmi all

echo "Run new container..."
docker-compose up -d --build
