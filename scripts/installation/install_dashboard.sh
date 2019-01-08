#!/usr/bin/env bash

# use the specification in the file
kubectl apply -f kubernetes-dashboard.yaml

# create user
kubectl -n kube-system create sa dashboard-admin
kubectl create clusterrolebinding dashboard-admin --clusterrole cluster-admin --serviceaccount=kube-system:dashboard-admin


