#!/bin/bash

echo "=== Cleaning up Scenario 05 ==="

kubectl delete hpa apache-server -n autoscale --ignore-not-found
kubectl delete service apache-deployment -n autoscale --ignore-not-found
kubectl delete deployment apache-deployment -n autoscale --ignore-not-found
kubectl delete ns autoscale --ignore-not-found

echo "=== Cleanup complete ==="
