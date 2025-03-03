#!/bin/bash
docker compose -f co.yaml down -v
docker rmi $(docker images 'dev-peer0.co.com*' -q)
docker volume prune --force
docker image prune --force