# aws - follow instructions to install with pip and configure

# kubectl - follow instructions

https://github.com/kubernetes/kops/blob/master/docs/aws.md

# kops
curl -Lo kops https://github.com/kubernetes/kops/releases/download/1.10.0/kops-linux-amd64
chmod +x ./kops
sudo mv ./kops /usr/local/bin/

# # Setup the AWS profile
# aws configure


# Create the IAM user, groups, roles
aws iam create-group --group-name kops

aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops

aws iam create-user --user-name kops
aws iam add-user-to-group --user-name kops --group-name kops

# make the bucket for state store
aws iam create-access-key --user-name kops
aws configure

# https://github.com/kubernetes/kops/blob/master/docs/aws.md
# need to redo this in a few hours
STATE_BUCKET=ds-k8s-state-store
aws s3api create-bucket  --bucket ds-k8s-cluster-state --create-bucket-configuration LocationConstraint=eu-central-1 --region eu-central-1
aws s3api put-bucket-versioning --bucket ds-k8s-cluster-state  --versioning-configuration Status=Enabled


insepct scluster:
kops edit cluster ds-cluster.k8s.local

inspect nodes
kops edit ig  --name=ds-cluster.k8s.local nodes

inspect master
kops edit ig  --name=ds-cluster.k8s.local master
