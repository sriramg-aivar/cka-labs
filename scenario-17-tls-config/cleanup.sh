#!/bin/bash

echo "=== Cleaning up Scenario 17 ==="

NS="nginx-static"

kubectl -n "$NS" delete deployment nginx-static --ignore-not-found
kubectl -n "$NS" delete service nginx-static --ignore-not-found
kubectl -n "$NS" delete configmap nginx-config --ignore-not-found
kubectl -n "$NS" delete secret nginx-tls --ignore-not-found
kubectl delete ns "$NS" --ignore-not-found

# Remove the /etc/hosts entry added during the task, if present.
if [ -f /etc/hosts ] && grep -q 'ckaquestion.k8s.local' /etc/hosts 2>/dev/null; then
  echo "Removing ckaquestion.k8s.local from /etc/hosts..."
  sudo sed -i '/ckaquestion.k8s.local/d' /etc/hosts 2>/dev/null || \
    echo "(could not edit /etc/hosts; remove the line manually if needed)"
fi

echo "=== Cleanup complete ==="
