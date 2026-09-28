#!/bin/bash

echo "=== Cleaning up Scenario 13 ==="

kubectl delete ns frontend --ignore-not-found
kubectl delete ns backend --ignore-not-found
rm -rf /root/network-policies

echo "=== Cleanup complete ==="
