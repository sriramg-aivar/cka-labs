#!/bin/bash

echo "=== Checking Scenario 02: Install Argo CD via Helm without CRDs ==="
echo ""

FAILED=0

echo -n "CHECK 1: /root/argo-helm.yaml exists and is non-empty... "
if [ -s /root/argo-helm.yaml ]; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: manifest does NOT contain any CustomResourceDefinition... "
if [ -f /root/argo-helm.yaml ] && ! grep -q "kind: CustomResourceDefinition" /root/argo-helm.yaml; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 3: namespace 'argocd' exists... "
if kubectl get ns argocd &>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "=== Results ==="
if [ $FAILED -eq 0 ]; then
  echo "ALL CHECKS PASSED ✅"
  exit 0
else
  echo "$FAILED CHECK(S) FAILED ❌"
  exit 1
fi
