#!/bin/bash

echo "=== Cleaning up Scenario 07 ==="

kubectl delete deployment busybox-logger -n priority --ignore-not-found
kubectl delete priorityclass high-priority --ignore-not-found
kubectl delete priorityclass user-critical --ignore-not-found
kubectl delete ns priority --ignore-not-found

echo "=== Cleanup complete ==="
