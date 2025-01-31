#!/bin/bash
docker compose -f retail.yaml down -v
docker rmi $(docker images 'dev-peer0.retail.com*' -q)
docker volume prune --force
docker image prune --force