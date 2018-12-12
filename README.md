

```bash
# I suggest adding these to your zsh/bash profile
# Obviously have to think of your own name :)
export K8_NAME=k8s_4ds.k8s.local
export KOPS_STATE_STORE=s3://ds-k8s_4ds-state
export K8_AWS_REGION=eu-west-2a
export AWS_ACCESS_KEY=$(cat ~/.aws/credentials| grep key_id | awk '{print $3}')
export AWS_SECRET_KEY=$(cat ~/.aws/credentials| grep secret | awk '{print $3}')
```


