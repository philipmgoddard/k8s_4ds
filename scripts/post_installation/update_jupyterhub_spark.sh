#!/usr/bin/env bash

NAMESPACE=jhub
USERNAME=phil

# create cluster binding for jupyter service account (only needs doing once)

# QUESTION - why not do like this? what is difference???
# TRY THIS
# kubectl -n spark create sa spark-admin
# kubectl create clusterrolebinding spark-admin --clusterrole cluster-admin --serviceaccount=spark:spark-admin


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


# modify label for pod
kubectl label -n ${NAMESPACE} pods jupyter-${USERNAME} app=jupyterhub-${USERNAME} --overwrite

# create service

kubectl create -f - <<EOF
kind: Service
apiVersion: v1
metadata:
  name: jupyterhub-${USERNAME}
spec:
  clusterIP: None
  selector:
    app: jupyterhub-${USERNAME}
  ports:
  - protocol: TCP
    port: 9090
    targetPort: 9090
EOF



