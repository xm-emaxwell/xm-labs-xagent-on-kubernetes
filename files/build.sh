#!/bin/bash

registry=$(cat agent.config | jq -r ".xagent_container_registry")

docker build -t $registry:latest docker/Dockerfile
docker push $registry