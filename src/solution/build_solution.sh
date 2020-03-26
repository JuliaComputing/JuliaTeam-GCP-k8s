#!/bin/bash

export REGISTRY=gcr.io/juliacomputing-public
export TAG=1.3.2
export TEAMSERVER_VERSION="v${TAG}"
export MARKETPLACE_TOOLS_TAG="0.10.0"
echo "Building version ${TAG}"
make clean && make app/build
