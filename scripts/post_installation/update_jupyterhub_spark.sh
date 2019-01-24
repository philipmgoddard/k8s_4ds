#!/usr/bin/env bash

NAMESPACE=jhub
USERNAME=phil

########################
# create cluster binding for jupyter service account (only needs doing once)
# is this equivalent to
# kubectl -n jhub create sa jupyter-notebook
# kubectl create clusterrolebinding jupyter-notebook --clusterrole cluster-admin --serviceaccount=jhub:jupyter-notebook
########################

kubectl create -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: jupyter-notebook
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: jupyter-notebook
  namespace: ${NAMESPACE}
EOF

########################
# modify label for pod
# only run this when your pod jupyter-${USERNAME} is ready!
# this is so the service can pick up the pod
########################

kubectl label -n ${NAMESPACE} pods jupyter-${USERNAME} app=jupyter-${USERNAME} --overwrite


########################
# create service for the driver
# question- why not in jhub namespace? Make another in tmp_jhub_service.yaml- apply in namespace
########################

kubectl create -f - <<EOF
kind: Service
apiVersion: v1
metadata:
  name: jupyterhub-${USERNAME}
spec:
  clusterIP: None
  selector:
    app: jupyter-${USERNAME}
  ports:
  - protocol: TCP
    port: 9090
    targetPort: 9090
EOF




