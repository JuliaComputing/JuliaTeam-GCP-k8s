#!/bin/bash

# E.g. ./run_mpdev.sh juliacomputing-public  us-central1-a 1.3.2
if [ $# -lt 3 ]; then
    echo "Usage: $0 <project> <zone> <version>"
    exit 1
fi

project=$1
zone=$2
TAG=$3

cur_project=$(gcloud config get-value project)
cur_zone=$(gcloud config get-value compute/zone)

gcloud config set project $project
gcloud config set compute/zone $zone

# kubectl create ns juliateam
# kubectl create ns juliarun

JCAUTHTOKEN=${JC_AUTH_TOKEN}
echo "JC_AUTH_TOKEN = ${JCAUTHTOKEN}"
# export DEPLOYER_SERVICE_ACCOUNT=myapp-deployer-sa

## install - development
/home/juliateam/bin/mpdev publish --deployer_image=gcr.io/juliacomputing-public/juliateam-app/deployer:${TAG} \
  --gcs_repo=gs://jc-mktplace/juliacomputing/juliateam-app/1_3

/home/juliateam/bin/mpdev install \
  --version_meta_file=gs://jc-mktplace/juliacomputing/juliateam-app/1_3/${TAG}.yaml \
  --parameters='{"APP_INSTANCE_NAME": "myapp", "NAMESPACE": "juliateam", "JC_AUTH_TOKEN": "$JCAUTHTOKEN"}'



## install from marketplace UI
# /home/juliateam/bin/mpdev install --deployer=gcr.io/juliacomputing-public/juliateam-app/deployer:${TAG} --parameters='{"APP_INSTANCE_NAME": "myapp", "NAMESPACE": "juliateam", "JC_AUTH_TOKEN": "JC_AUTH_TOKEN"}'
# /home/juliateam/bin/mpdev verify --deployer=gcr.io/juliacomputing-public/juliateam-app/deployer:${TAG}

gcloud config set project $cur_project
gcloud config set compute/zone $cur_zone
