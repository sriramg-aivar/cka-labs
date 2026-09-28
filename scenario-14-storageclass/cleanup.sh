#!/bin/bash

echo "=== Cleaning up Scenario 14 ==="

kubectl delete sc local-storage --ignore-not-found

# The student may have unset the default on local-path — try to restore it.
echo "Attempting to restore 'local-path' as the default StorageClass..."
kubectl patch sc local-path \
  -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}' \
  >/dev/null 2>&1 || echo "(could not restore local-path default; restore manually if needed)"

echo "=== Cleanup complete ==="
