#!/bin/bash

echo "=== Cleaning up Scenario 01 ==="

kubectl delete deployment mariadb -n mariadb --ignore-not-found
kubectl delete pvc mariadb -n mariadb --ignore-not-found
kubectl delete pv mariadb-pv --ignore-not-found
rm -f "${HOME}/mariadb-deploy.yaml"

echo "=== Cleanup complete ==="
