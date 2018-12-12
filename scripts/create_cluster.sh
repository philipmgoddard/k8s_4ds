#!/usr/bin/env bash

set -e

kops create cluster \
    --cloud aws \
    --zones ${K8_AWS_AZ} \
    ${K8_NAME}
    # --state=${KOPS_STATE_STORE}

kops replace -f - <<EOF
apiVersion: kops/v1alpha2
kind: Cluster
metadata:
  name: ${K8_NAME}
spec:
  api:
    loadBalancer:
      type: Public
      idleTimeoutSeconds: 3600
  authorization:
    rbac: {}
  channel: stable
  cloudProvider: aws
  etcdClusters:
  - etcdMembers:
    - instanceGroup: master-${K8_AWS_AZ}
      name: a
      volumeSize: 5
    name: main
  - etcdMembers:
    - instanceGroup: master-${K8_AWS_AZ}
      name: a
      volumeSize: 5
    name: events
  iam:
    allowContainerRegistry: true
    legacy: false
  kubernetesApiAccess:
  - 0.0.0.0/0
  kubernetesVersion: 1.10.6
  networkCIDR: 172.20.0.0/16
  networking:
    kubenet: {}
  nonMasqueradeCIDR: 100.64.0.0/10
  sshAccess:
  - 0.0.0.0/0
  subnets:
  - cidr: 172.20.32.0/19
    name: ${K8_AWS_AZ}
    type: Public
    zone: ${K8_AWS_AZ}
EOF


kops replace -f - <<EOF
apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: ${K8_NAME}
  name: nodes
spec:
  machineType: t2.xlarge
  maxPrice: "0.0743"
  maxSize: 1
  minSize: 1
  rootVolumeSize: 64
  rootVolumeType: standard
  role: Node
  subnets:
  - ${K8_AWS_AZ}
EOF

kops replace -f - <<EOF
apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: ${K8_NAME}
  name: master-${K8_AWS_AZ}
spec:
  machineType: m3.medium
  maxSize: 1
  minSize: 1
  rootVolumeSize: 32
  rootVolumeType: standard
  role: Master
  subnets:
  - ${K8_AWS_AZ}
EOF

kops update cluster ${K8_NAME} --yes

while [ 1 ]; do
    kops validate cluster ${K8_NAME} && break || sleep 30
done;

# echo "Installing dashboard"
# ./install_dashboard.sh

# if [ $? -eq 0 ]; then
#     echo "INSTALLATION SCRIPTS COMPLETE"
# else
#     echo "ERROR IN INSTALLATION SCRIPTS"
# fi
