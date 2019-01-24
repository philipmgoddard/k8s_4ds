#!/usr/bin/env bash

kubectl create ns spark

kubectl -n spark create sa spark-admin
kubectl create clusterrolebinding spark-admin --clusterrole cluster-admin --serviceaccount=spark:spark-admin
