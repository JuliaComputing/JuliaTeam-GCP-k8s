#!/bin/bash

# E.g. ./test_deploy_delete.sh create|delete juliacomputing-public  us-central1-a
if [ $# -lt 3 ]; then
    echo "Usage: $0 <create | delete> <project> <zone>"
    exit 1
fi

REGISTRY_PATH="gcr.io\/juliacomputing-public\/juliateam-app"
JC_AUTH_TOKEN="${JC_AUTH_TOKEN}"

# Update these as appropriate or set env variables
JULIATEAM_APP_SHA=${JULIATEAM_APP_SHA:=144ac91108025395c36496b694bf48f27ce0e5a3cae5ee704b22c0d2d18d89e1}
UBBAGENT_APP_SHA=${UBBAGENT_APP_SHA:=9e8bae6bf6cd825a4d20f5a08ecfa3ea0e5b726ce7719f750eee54774a17e39b}
BILLING_AGENT_APP_SHA=${BILLING_AGENT_APP_SHA:=9d4b6e29a716a21504d66c8a2e6277ab57ae089e061e665788e8985171410e80}


# E.g. ./test_deploy_delete.sh delete juliacomputing-public  us-central1-a
if [ $# -lt 3 ]; then
    echo "Usage: $0 <create | delete> <project> <zone>"
    exit 1
fi
action=$1
project=$2
zone=$3

cur_project=$(gcloud config get-value project)
cur_zone=$(gcloud config get-value compute/zone)

gcloud config get-value project
gcloud config get-value compute/zone
kubectl get nodes

function take_action() {
    COMMAND="kubectl $1 -f -"
    gcloud config set project $project
    gcloud config set compute/zone $zone
    cat ./manifest/manifests.yaml \
        | sed "s/\$IMAGE_JULIATEAM_APP/${REGISTRY_PATH}@sha256:${JULIATEAM_APP_SHA}/g" \
        | sed "s/\$IMAGE_UBBAGENT/${REGISTRY_PATH}\/ubbagent@sha256:${UBBAGENT_APP_SHA}/g" \
        | sed "s/\$IMAGE_BILLING_USAGE_REPORT_APP/${REGISTRY_PATH}\/jtbillingapp@sha256:${BILLING_AGENT_APP_SHA}/g" \
        | sed "s/\$JULIATEAM_HOSTNAME//g" \
        | sed "s/\$OVERWRITE/true/g" \
        | sed "s/\$CLUSTER_NODE_POOL_PREFIX/cluster1/g" \
        | sed "s/\$CPU_POOL_NAME/pool-1/g" \
        | sed "s/\$GPU_POOL_NAME/pool-2/g" \
        | sed "s/\$JC_AUTH_TOKEN/${JC_AUTH_TOKEN}/g" \
        | ${COMMAND}
    gcloud config set project $cur_project
    gcloud config set compute/zone $cur_zone
}

if [ "$action" = "create" ]; then
    echo "Creating deployment"
    take_action "$action"
elif [ "$action" = "delete" ]; then
    echo "Deleting deployment"
    take_action "$action"
elif [ "$action" = "recreate" ]; then
    echo "Recreating deployment"
    take_action "delete"
    take_action "create"
else
    echo "Unknown action: $action"
    exit 2
fi
