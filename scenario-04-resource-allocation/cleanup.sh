#!/bin/bash

echo "=== Cleaning up Scenario 04 ==="

kubectl delete deployment wordpress -n default --ignore-not-found

echo "=== Cleanup complete ==="
