#!/bin/bash
docker compose -f retail.yaml down -v
docker rmi $(docker images 'dev-*' -q)