#!/bin/bash

wget https://github.com/mikefarah/yq/releases/download/v4.9.6/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

registry=$(cat agent.config | jq -r ".xagent_container_registry")
yq eval '.spec.template.spec.containers[0].image = "'$registry'"' -i kube/xagent.deploy.yaml

xm_host_url=$(cat agent.config | jq -r ".xmatters_host_url")
yq eval '.spec.template.spec.containers[0].env[0].value = "'$xm_host_url'"' -i kube/xagent.deploy.yaml

xagent_friendly_name=$(cat agent.config | jq -r ".xagent_friendly_name")
yq eval '.spec.template.spec.containers[0].env[3].value = "'$xagent_friendly_name'"' -i kube/xagent.deploy.yaml

xmatters_key=$(cat agent.config | jq -r ".xmatters_key")
encoded_xmatters_key=$(echo -n $xmatters_key | base64)
yq eval '.data.WEBSOCKET_SECRET = "'$encoded_xmatters_key'"' -i kube/xagent.secrets.yaml

xmatters_api_key=$(cat agent.config | jq -r ".xmatters_api_key")
encoded_xmatters_api_key=$(echo -n $xmatters_api_key | base64)
yq eval '.data.OWNER_API_KEY = "'$encoded_xmatters_api_key'"' -i kube/xagent.secrets.yaml

kubectl apply -f kube/role.yaml
kubectl create -f kube/xagent.secrets.yaml
kubectl create -f kube/xagent.deploy.yaml

