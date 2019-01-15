# K8's for DS

A repo to accompany my blog posts

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

To get IP for jupyterhub, run

```bash
kubectl get service --namespace jhub
```


First, difficulty is with public ip of load balancer
Set up hub
First install takes a while
DO NOT start any notebooks
Go to github, make an authenticator
Add this to jupyterconfig.yaml
```yaml
auth:
  type: github
  github:
    clientId: [ID]
    clientSecret: [SECRTE]
    callbackUrl: [callback url]
  whitelist:
    users:
      - philipmgoddard
  admin:
    users:
      - philipmgoddard
```
Then run ```helm upgrade  jhub jupyterhub/jupyterhub --namespace jhub --version 0.7.0 -f jupyterconfig.yaml --recreate-pods```



Questions on PV's
https://kubernetes.io/docs/concepts/storage/persistent-volumes/#volume-snapshot-and-restore-volume-from-snapshot-support

try this?? just sync to S3??

https://serverfault.com/questions/759484/sync-a-folder-on-ubuntu-server-with-amazon-s3-bucket-automatically

https://github.com/s3fs-fuse/s3fs-fuse

will have to use secrets etc - fine!
