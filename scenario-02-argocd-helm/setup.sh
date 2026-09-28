#!/bin/bash
set -e

echo "=== Setting up Scenario 02: Install Argo CD via Helm without CRDs ==="

# Clean any prior state
rm -f /root/argo-helm.yaml 2>/dev/null || true
kubectl delete ns argocd --ignore-not-found >/dev/null 2>&1 || true

# Create the target namespace
kubectl create ns argocd --dry-run=client -o yaml | kubectl apply -f -

if ! command -v helm >/dev/null 2>&1; then
  echo ""
  echo "WARNING: 'helm' is not installed. This scenario requires Helm."
  echo "         Install it before attempting the task (https://helm.sh/docs/intro/install/)."
fi

echo ""
echo "=== Setup complete ==="
echo "  - Namespace 'argocd' created"
echo "  - NOTE: Argo CD CRDs are assumed pre-installed; do NOT render them"
echo "  - Render the chart and save it to /root/argo-helm.yaml"
echo ""
echo "See TASK.md for full instructions."
