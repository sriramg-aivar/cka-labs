#!/bin/bash
set -e

echo "=== Setting up Scenario 15: Fix kube-apiserver etcd Endpoint ==="

MANIFEST="/etc/kubernetes/manifests/kube-apiserver.yaml"
BACKUP="/root/kube-apiserver.yaml.bak"

if [ -f "$MANIFEST" ]; then
  echo "Backing up $MANIFEST to $BACKUP..."
  sudo cp "$MANIFEST" "$BACKUP"

  echo "Breaking the manifest: pointing etcd endpoints at the PEER port 2380..."
  sudo sed -i 's/:2379/:2380/g' "$MANIFEST"

  echo ""
  echo "The kube-apiserver static pod will now restart and FAIL to reach etcd."
  echo "It may take a moment for the API server to become unreachable."
else
  echo "NOTE: $MANIFEST not found."
  echo "This scenario requires a kubeadm control-plane node (e.g. Killercoda controlplane)."
  echo "No changes were made."
fi

echo ""
echo "=== Setup complete ==="
echo "See TASK.md for full instructions."
