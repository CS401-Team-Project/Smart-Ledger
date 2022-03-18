#!/bin/bash
echo "# CONTAINERS"
docker ps

echo
echo "# DOWN..."
docker-compose down --rmi=all --volumes --remove-orphans

echo
echo "# DISK USAGE"
docker system df

echo
echo "# CONTAINERS"
docker container ls

echo
echo "# IMAGE"
docker image ls

echo
echo "# VOLUMES"
docker volume ls

echo
echo "# NETWORKS"
docker network ls

echo
echo "# CONTAINERS"
docker ps

echo
echo "# GIT"
git reset --hard HEAD
git clean -f
git pull

echo
echo "# UP..."
docker-compose up -d

echo
echo "# CONTAINERS"
docker ps
