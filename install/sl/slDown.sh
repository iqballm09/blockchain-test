#!/bin/bash
docker compose -f sl.yaml down -v
docker rmi $(docker images 'dev-peer0.sl.com*' -q)
docker volume prune --force
docker image prune --force