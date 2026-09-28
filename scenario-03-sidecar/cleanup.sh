#!/bin/bash

echo "=== Cleaning up Scenario 03 ==="

kubectl delete deployment wordpress -n default --ignore-not-found
kubectl delete service wordpress -n default --ignore-not-found

echo "=== Cleanup complete ==="
