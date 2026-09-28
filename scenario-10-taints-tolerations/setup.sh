#!/bin/bash
set -e

echo "=== Setting up Scenario 10: Taints & Tolerations ==="

# Clean any prior state from a previous run
kubectl delete pod nginx --ignore-not-found >/dev/null 2>&1 || true
kubectl delete pod nginx-fail --ignore-not-found >/dev/null 2>&1 || true
kubectl taint nodes node01 PERMISSION=granted:NoSchedule- >/dev/null 2>&1 || true

echo ""
echo "=== Setup complete ==="
echo "  - No application resources were pre-created."
echo "  - You will taint node 'node01' and schedule a tolerating pod onto it."
echo ""
echo "See TASK.md for full instructions."
