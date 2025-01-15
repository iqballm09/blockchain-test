#!/bin/bash
docker compose -f distributor.yaml down -v
docker rmi $(docker images 'dev-*' -q)
docker volume prune -y