# K8's for DS

A repo to accompany my blog posts. This branch is for post 3: setting up Spark on Kubernetes


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

Spark:


mention that jupyter covered in section X, so skip down to that if its all you are interested in

Example 1: just run with local spark against cluster
install (i did 2.4.0) need this for client mode. when we first started needed the rc branches
use the docker-image-tool.sh, or reference the one in my repo

use the example, check the logs on the pods

driver gets made, starts executors,

Obvs can run this from within a pod in the cluster



Example 2: Make image with custom spark application
needs a lot of boilerplate, but ok

Example 3: client mode

kubectl apply -f spark-driver-service.yaml -n spark
kubectl apply -f spark-pod.yaml -n spark

kubectl exec -it spark-pod -n spark bash

./bin/spark-shell \
    --master k8s://https://kubernetes.default \
    --deploy-mode client \
    --name spark-shell-app \
    --conf spark.driver.host=spark-driver \
    --conf spark.driver.port=9090 \
    --conf spark.driver.pod.name=spark-pod \
    --conf spark.executor.instances=2 \
    --conf spark.kubernetes.driver.limit.cores=1 \
    --conf spark.kubernetes.executor.limit.cores=2 \
    --conf spark.executor.cores=1 \
    --conf spark.driver.cores=1 \
    --conf spark.kubernetes.container.image=docker.io/pmgoddard89/spark:v2.4.0 \
    --conf spark.kubernetes.allocation.batch.size=1 \
    --conf spark.kubernetes.namespace=spark \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark-admin

look on dashboard and see the pods yaay :)

This doesnt work locally- the driver service is needed for client mode. TODO: ask tamas why the driver cant be on local machine? could be dumb question, but i wonder if possible at all...

example 4: jupyetr

make the service, make the pod
start notebook, and update


try using docker stack version?

import os
os.environ["PYSPARK_DRIVER_PYTHON"] = "/opt/conda/bin/python3.6"
os.environ["PYSPARK_PYTHON"] = "/usr/bin/python3.6"
import pyspark

spark = (pyspark.sql
         .SparkSession
         .builder
         .appName("kube-test")
         .master("k8s://https://kubernetes.default")
         .config("spark.submit.deployMode", "client")
         # this is the service
         .config("spark.driver.host", "jupyterhub-phil")
         .config("spark.driver.port", 9090)
         # this is the pod
         .config("spark.driver.pod.name", "jupyter-phil")
         .config("spark.executor.instances", 1)
         .config("spark.kubernetes.driver.limit.cores", 1)
         .config("spark.kubernetes.executor.limit.cores", 2)
         .config("spark.executor.cores",1)
         .config("spark.driver.cores", 1)
         .config("spark.kubernetes.container.image", "docker.io/phigod/spark-py:v2.4.0") # what should this be??
         .config("spark.kubernetes.allocation.batch.size",1)
         .config("spark.kubernetes.namespace", "jhub") # MAKE SURE CORRECT NAMESPACE
         .config("spark.kubernetes.authenticate.driver.serviceAccountName", "jupyter-notebook")
         .getOrCreate())

bah doesnt work- need help from tamas


Other comments:
STreaming with checkpoints- need to build against hadoop 3
Install kafka and demo - next time
