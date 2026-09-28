#!/bin/bash
set -e

echo "=== Setting up Scenario 16: NodePort Service ==="

kubectl create ns relative --dry-run=client -o yaml | kubectl apply -f -

# Clean any prior state
kubectl -n relative delete svc nodeport-service --ignore-not-found >/dev/null 2>&1 || true
kubectl -n relative delete deployment nodeport-deployment --ignore-not-found >/dev/null 2>&1 || true

echo "Creating deployment 'nodeport-deployment' (nginx, 2 replicas)..."
kubectl -n relative create deployment nodeport-deployment --image=nginx --replicas=2

echo ""
echo "=== Setup complete ==="
echo "  - Namespace: relative"
echo "  - Deployment: nodeport-deployment (nginx, 2 replicas)"
echo "  - No named container port yet; no Service yet."
echo ""
echo "See TASK.md for full instructions."
