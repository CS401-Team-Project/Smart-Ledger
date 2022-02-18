#!/bin/bash

echo Delete old containers...
docker rm -f mongo smart-ledger-api-1 smart-ledger-client-1

echo Run new container...
docker-compose up -d --build