# JuliaTeam-GCP-k8s
This repo contains the CLI instructions that could be used to deploy JuliaTeam on GCP


# Overview

JuliaTeam Application

For more information on JuliaTeam Application, see the
[JuliaTeam product website](https://juliacomputing.com/products/juliateam.html).

## About Google Click to Deploy

Popular open source software stacks on Kubernetes packaged by Google and made
available in Google Cloud Marketplace.

# Installation

## Quick install with Google Cloud Marketplace

Get up and running with a few clicks! Install this JuliaTeam Application to a
Google Kubernetes Engine cluster using Google Cloud Marketplace. Follow the
[on-screen instructions](https://console.cloud.google.com/marketplace/details/google/juliateam-app).

## Command line instructions

You can use [Google Cloud Shell](https://cloud.google.com/shell/) or a local
workstation to follow the steps below.

[![Open in Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/GoogleCloudPlatform/click-to-deploy&cloudshell_open_in_editor=README.md&cloudshell_working_dir=k8s/juliateam-app)

### Prerequisites

#### Set up command line tools

You'll need the following tools in your development environment. If you are
using Cloud Shell, `gcloud`, `kubectl`, Docker, and Git are installed in your
environment by default.

-   [gcloud](https://cloud.google.com/sdk/gcloud/)
-   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
-   [docker](https://docs.docker.com/install/)
-   [openssl](https://www.openssl.org/)

Configure `gcloud` as a Docker credential helper:

```shell
gcloud auth configure-docker
```

#### Create a Google Kubernetes Engine cluster

Create a cluster from the command line. If you already have a cluster that you
want to use, this step is optional.

```shell
export CLUSTER=juliateamcluster
export ZONE=us-west1-a

gcloud container clusters create "$CLUSTER" \
    --num-nodes=2 \
    --machine-type=n1-standard-4 \
    --zone="$ZONE" \
    --enable-autoscaling \
    --min-nodes=1 \
    --max-nodes=3 \
    --node-labels=juliarun/cpu\=low,juliarun/gpu\=none,juliarun/schedule\=yes
```

#### Configure kubectl to connect to the cluster

```shell
gcloud container clusters get-credentials "$CLUSTER" --zone "$ZONE"
```

#### Clone this repo

Clone this repo and the associated tools repo:

```shell
git clone --recursive https://github.com/GoogleCloudPlatform/click-to-deploy.git
```

#### Install the Application resource definition

An Application resource is a collection of individual Kubernetes components,
such as Services, Deployments, and so on, that you can manage as a group.

To set up your cluster to understand Application resources, run the following
command:

```shell
kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"
```

You need to run this command once for each cluster.

The Application resource is defined by the
[Kubernetes SIG-apps](https://github.com/kubernetes/community/tree/master/sig-apps)
community. The source code can be found on
[github.com/kubernetes-sigs/application](https://github.com/kubernetes-sigs/application).

### Install the Application

Navigate to the `juliateam-app` directory:

```shell
cd click-to-deploy/k8s/juliateam-app
```

#### Configure the app with environment variables

Choose an instance name and
[namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
for the app. In most cases, you can use the `default` namespace.

```shell
export APP_INSTANCE_NAME=juliateam-app-1
export NAMESPACE=juliateam
```

Set the required parameters:

```shell
export JULIATEAM_HOSTNAME=""
export JC_AUTH_TOKEN="<<JC AUTH TOKEN obtained from Julia Computing>>"
export POOL_NAME="default-pool"

```

Configure the container image:

```shell
export IMAGE_JULIATEAM_APP="marketplace.gcr.io/juliacomputing/juliateam-app:1.1"
```

The image above is referenced by
[tag](https://docs.docker.com/engine/reference/commandline/tag). We recommend
that you pin each image to an immutable
[content digest](https://docs.docker.com/registry/spec/api/#content-digests).
This ensures that the installed application always uses the same images until
you are ready to upgrade. To get the digest for the image, use the following
script:

```shell
export IMAGE_JULIATEAM_APP=$(docker pull $IMAGE_JULIATEAM_APP | awk -F: "/^Digest:/ {print gensub(\":.*$\", \"\", 1, \"$IMAGE_JULIATEAM_APP\")\"@sha256:\"\$3}")
```

#### Expand the manifest template

Use `envsubst` to expand the template. We recommend that you save the expanded
manifest file for future updates to the application.

```shell
awk 'FNR==1 {print "---"}{print}' manifest/* \
  | envsubst '$APP_INSTANCE_NAME $NAMESPACE $IMAGE_JULIATEAM_APP $JULIATEAM_APP_PARAMETER1' \
  > "${APP_INSTANCE_NAME}_manifest.yaml"
```

#### Apply the manifest to your Kubernetes cluster

Use `kubectl` to apply the manifest to your Kubernetes cluster.

```shell
kubectl apply -f "${APP_INSTANCE_NAME}_manifest.yaml" --namespace "${NAMESPACE}"
```

#### View the app in the Google Cloud Console

To get the Console URL for your app, run the following command:

```shell
echo "https://console.cloud.google.com/kubernetes/application/${ZONE}/${CLUSTER}/${NAMESPACE}/${APP_INSTANCE_NAME}"
```

To view the app, open the URL in your browser.

# Using the app

## How to use JuliaTeam Application

How to use JuliaTeam App

## Customize the installation

To set JuliaTeam App, follow these on-screen steps to customize your installation:

> Add steps to customize the application, if applicable. Delete this note when
you start editing.

# Scaling
The cluster is set to autoscale. The cluster will scale as required by the jobs running on them.

# Backup and restore

How to backup and restore JuliaTeam Application

## Backing up JuliaTeam Application
It is important to backup the disk on which JuliaTeam config folder exist. Look for the `juliateam-data` disk in the project where JuliaTeam is installed and backup the disk.

## Restoring your data
Rename the restored disk and `juliateam-data` and restart the application by running `bootstrap.sh` command. See https://storage.googleapis.com/marketplaceresources/JuliaTeam-v1.1.0-Installation-Guide.pdf for more details.

# Updating

# Logging and Monitoring
