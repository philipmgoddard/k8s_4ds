#!/usr/bin/env bash

# service account for tiller
kubectl --namespace kube-system create serviceaccount tiller

# give service account full persmission for cluster
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

helm init --service-account tiller
