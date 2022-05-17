#!/bin/bash

gcloud services enable dataproc.googleapis.com \
  compute.googleapis.com \
  storage-component.googleapis.com \
  bigquery.googleapis.com \
  bigquerystorage.googleapis.com

REGION=us-central1
BUCKET_NAME=$(gcloud config get-value project)

gsutil mb -c standard -l ${REGION} gs://${BUCKET_NAME}

ZONE=us-central1-a
CLUSTER_NAME=spark-jupyter

gcloud beta dataproc clusters create ${CLUSTER_NAME} \
 --region=${REGION} \
 --image-version=2.0 \
 --master-machine-type=n1-standard-4 \
 --worker-machine-type=n1-standard-4 \
 --bucket=${BUCKET_NAME} \
 --optional-components=ANACONDA,JUPYTER \
 --enable-component-gateway 