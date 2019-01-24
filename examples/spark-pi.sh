#!/usr/bin/env bash

PATH_TO_SPARK=~/Desktop/spark-2.4.0-bin-hadoop2.7/bin
MASTER_K8=https://api-ds-k8s-cluster-k8s-lo-78dk7t-507905329.eu-central-1.elb.amazonaws.com

${PATH_TO_SPARK}/spark-submit \
   --master k8s://${MASTER_K8} \
   --deploy-mode cluster \
   --name spark-pi \
   --class org.apache.spark.examples.SparkPi \
   --conf spark.executor.instances=2 \
   --conf spark.kubernetes.driver.limit.cores=1 \
   --conf spark.kubernetes.executor.limit.cores=1 \
   --conf spark.executor.cores=1 \
   --conf spark.driver.cores=1 \
   --conf spark.kubernetes.container.image=docker.io/pmgoddard89/spark:v2.4.0 \
   --conf spark.kubernetes.allocation.batch.size=1 \
   --conf spark.kubernetes.namespace=spark \
   --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark-admin \
   local:///opt/spark/examples/jars/spark-examples_2.11-2.4.0.jar 1000
