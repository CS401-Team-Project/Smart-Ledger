#!/bin/bash

echo Delete old containers...
docker rm -f mongo smart-ledger-api smart-ledger-client

echo Delete old volumes...
docker volume rm -f smart-ledger_appdata smart-ledger_mongodbdata

echo Run new container...
docker-compose up -d --build
