#!/bin/bash

echo "=== Cleaning up Scenario 02 ==="

rm -f /root/argo-helm.yaml
kubectl delete ns argocd --ignore-not-found
helm repo remove argocd >/dev/null 2>&1 || true

echo "=== Cleanup complete ==="
