#!/bin/bash
set -e

echo "=== Setting up Scenario 14: Default StorageClass ==="

echo "Current StorageClasses:"
kubectl get sc 2>/dev/null || echo "(unable to list StorageClasses)"

# Ensure there is no leftover local-storage SC from a prior run
kubectl delete sc local-storage --ignore-not-found >/dev/null 2>&1 || true

echo ""
echo "=== Setup complete ==="
echo "  - The cluster ships with a 'local-path' StorageClass (usually default)."
echo "  - You must create 'local-storage' and make it the ONLY default."
echo ""
echo "See TASK.md for full instructions."
