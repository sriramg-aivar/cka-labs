#!/bin/bash

echo "=== Cleaning up Scenario 15 ==="

MANIFEST="/etc/kubernetes/manifests/kube-apiserver.yaml"
BACKUP="/root/kube-apiserver.yaml.bak"

if [ -f "$BACKUP" ]; then
  echo "Restoring original manifest from $BACKUP..."
  sudo cp "$BACKUP" "$MANIFEST"
  echo "Restored. The kube-apiserver static pod will restart."
else
  echo "NOTE: backup $BACKUP not found."
  echo "If the API server is broken, restore the manifest manually so"
  echo "--etcd-servers uses https://127.0.0.1:2379."
fi

echo "=== Cleanup complete ==="
