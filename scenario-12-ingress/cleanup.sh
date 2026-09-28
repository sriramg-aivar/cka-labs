#!/bin/bash

echo "=== Cleaning up Scenario 12 ==="

kubectl delete ingress echo -n echo-sound --ignore-not-found
kubectl delete service echo-service -n echo-sound --ignore-not-found
kubectl delete deployment echo -n echo-sound --ignore-not-found
kubectl delete ns echo-sound --ignore-not-found

echo "=== Cleanup complete ==="
