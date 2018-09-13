#!/usr/bin/env bash

gcloud dataproc clusters create example-cluster2 \
        --num-workers=2 \
        --num-masters=1 \
        --zone=us-central1-a \
        --master-machine-type n1-standard-1 \
        --worker-machine-type n1-standard-1 \
        --project=single-portal-216120


gcloud dataproc --project=single-portal-216120 \
        jobs submit spark --cluster example-cluster2 \
        --class org.apache.spark.examples.SparkPi \
        --jars file:///usr/lib/spark/examples/jars/spark-examples.jar -- 1000


gcloud dataproc --project=single-portal-216120 \
        clusters update example-cluster2 --num-workers 3

gcloud dataproc --project=single-portal-216120 \
        clusters delete example-cluster2


gcloud dataproc --project=single-portal-216120 \
        jobs submit pyspark --cluster estimate-pi \
        gs://pyspark-dataproc/estimate_pi.py

gcloud beta dataproc workflow-templates --project=single-portal-216120 \
        create wf-template

gcloud beta dataproc workflow-templates set-managed-cluster wf-template \
        --project=single-portal-216120 \
        --num-workers 2 \
        --num-masters=1 \
        --zone=us-central1-a \
        --master-machine-type n1-standard-1 \
        --worker-machine-type n1-standard-1 \
        --cluster-name estimate-pi

gcloud beta dataproc workflow-templates list --project=single-portal-216120


gcloud beta dataproc workflow-templates add-job pyspark \
        --step-id foo \
        --project single-portal-216120 \
        --workflow-template wf-template gs://pyspark-dataproc/estimate_pi.py

gcloud beta dataproc workflow-templates instantiate wf-template \
        --project single-portal-216120


gcloud beta dataproc workflow-templates delete wf-template \
        --project single-portal-216120

gcloud dataproc operations list \
        --project single-portal-216120 \
        --filter "labels.goog-dataproc-operation-type=WORKFLOW AND status.state=RUNNING"

gcloud beta dataproc operations cancel \
        --project single-portal-216120 \
        8c9a4831-6419-4f9b-ab01-b78a93a9bf5e


gcloud dataproc clusters create example-cluster2 \
        --num-workers=2 \
        --num-masters=1 \
        --zone=us-central1-a \
        --master-machine-type n1-standard-1 \
        --worker-machine-type n1-standard-1 \
        --initialization-actions gs://pyspark-dataproc/init.sh \
        --project=single-portal-216120



gcloud beta dataproc workflow-templates --project=single-portal-216120 \
        create wf-template-init

gcloud beta dataproc workflow-templates set-managed-cluster wf-template-init \
        --project=single-portal-216120 \
        --num-workers 2 \
        --num-masters=1 \
        --zone=us-central1-a \
        --master-machine-type n1-standard-1 \
        --worker-machine-type n1-standard-1 \
        --initialization-actions gs://pyspark-dataproc/init.sh \
        --cluster-name estimate-pi

gcloud beta dataproc workflow-templates add-job pyspark \
        --step-id bar \
        --project single-portal-216120 \
        --workflow-template wf-template-init gs://pyspark-dataproc/estimate_pi_tqdm.py

gcloud beta dataproc workflow-templates instantiate wf-template-init \
        --project single-portal-216120


gcloud beta dataproc workflow-templates delete wf-template-init \
        --project single-portal-216120


gsutil cp init.sh gs://pyspark-dataproc/init.sh

gsutil cp estimate_pi_tqdm.py gs://pyspark-dataproc/estimate_pi_tqdm.py

