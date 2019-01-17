# K8's for DS

A repo to accompany my blog posts. This branch is for post 2: setting up a Jupyter Hub on Kubernetes

```bash
# I suggest adding these to your zsh/bash profile
# Obviously to use your own cluster name, and ensure your default
# aws profile is kops
export K8_NAME=ds-k8s-cluster.k8s.local
export KOPS_STATE_STORE=s3://ds-k8s-state-store
export K8_AWS_AZ=eu-central-1a
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile default)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile default)
```

To get the token for the dashboard, after running `kubectl proxy` run

```bash
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep dashboard-admin | awk '{print $1}')
```
