#!/bin/bash
docker compose -f distributor.yaml down -v
docker rmi $(docker images 'dev-peer0.distributor.com*' -q)
docker volume prune --force
docker image prune --force