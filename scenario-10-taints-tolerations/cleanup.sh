#!/bin/bash

echo "=== Cleaning up Scenario 10 ==="

kubectl delete pod nginx --ignore-not-found
kubectl delete pod nginx-fail --ignore-not-found
kubectl taint nodes node01 PERMISSION=granted:NoSchedule- || true

echo "=== Cleanup complete ==="
