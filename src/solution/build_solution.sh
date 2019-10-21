#!/bin/bash

export REGISTRY=gcr.io/juliacomputing-public
export TAG=1.1
make clean && make app/build
