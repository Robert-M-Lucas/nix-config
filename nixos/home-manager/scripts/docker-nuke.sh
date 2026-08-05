#!/usr/bin/env bash
docker ps -a --format '{{.Names}}' | grep -v persist | xargs -r docker rm -f && docker image prune -a -f