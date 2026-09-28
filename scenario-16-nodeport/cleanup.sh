#!/bin/bash

echo "=== Cleaning up Scenario 16 ==="

kubectl -n relative delete svc nodeport-service --ignore-not-found
kubectl -n relative delete deployment nodeport-deployment --ignore-not-found
kubectl delete ns relative --ignore-not-found

echo "=== Cleanup complete ==="
