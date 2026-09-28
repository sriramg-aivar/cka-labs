#!/bin/bash

echo "=== Cleaning up Scenario 06 ==="

rm -f /root/resources.yaml /root/subject.yaml

# Optionally remove the cert-manager CRDs and namespace (ignore errors)
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.0/cert-manager.crds.yaml --ignore-not-found >/dev/null 2>&1 || true
kubectl delete ns cert-manager --ignore-not-found >/dev/null 2>&1 || true

echo "=== Cleanup complete ==="
