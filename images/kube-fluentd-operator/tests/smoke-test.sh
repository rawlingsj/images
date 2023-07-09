#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail -x

sleep 5

# There are docs to test a deployment of the operator, but this is not
# working, same result with the upstream image. Instead, we will test the operator by
# deploying the log-router daemonset and checking that it is healthy.
# https://github.com/vmware/kube-fluentd-operator#try-it-out

# Wait for the deamonset to be ready
kubectl rollout status ds/kfo-sunny-llama-log-router -n kfo --timeout=120s

# Check the log-router pods are deployed and healthy
kubectl wait --for=condition=ready pod --selector app=log-router --timeout=120s -n kfo 