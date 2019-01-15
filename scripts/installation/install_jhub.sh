#!/usr/bin/env bash

RELEASE=jhub
NAMESPACE=jhub

# create jupyterconfig.yaml.
cat << EOF > jupyterconfig.yaml
proxy:
  secretToken: "$(openssl rand -hex 32)"
singleuser:
  image:
    name: jupyter/scipy-notebook:87210526f381
  memory:
    limit: 8G
    guarantee: 1G
  cpu:
    limit: 4
    guarantee: 0.5
EOF

# add the helm chart and update
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

helm upgrade --install $RELEASE jupyterhub/jupyterhub \
  --namespace $NAMESPACE  \
  --version 0.7.0 \
  --values jupyterconfig.yaml



# get external ip with this to point your browser
# kubectl get service --namespace jhub

# hop into pod
# kubectl exec -it jupyter-phil -n jhub bash
