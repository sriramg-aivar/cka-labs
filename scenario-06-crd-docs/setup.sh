#!/bin/bash
set -e

echo "=== Setting up Scenario 06: Extract CRD Documentation ==="

kubectl create ns cert-manager --dry-run=client -o yaml | kubectl apply -f -

echo "Applying cert-manager CRDs (v1.14.0)..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.0/cert-manager.crds.yaml

# Clean any prior answer files
rm -f /root/resources.yaml /root/subject.yaml >/dev/null 2>&1 || true

echo ""
echo "=== Setup complete ==="
echo "  - Namespace: cert-manager"
echo "  - cert-manager CRDs applied (v1.14.0)"
echo ""
echo "TASK:"
echo "  1. List all cert-manager CRDs -> /root/resources.yaml"
echo "  2. kubectl explain the Certificate spec.subject field -> /root/subject.yaml"
echo ""
echo "See TASK.md for full instructions."
