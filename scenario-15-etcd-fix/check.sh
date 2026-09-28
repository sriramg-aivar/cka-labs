#!/bin/bash

echo "=== Checking Scenario 15: Fix kube-apiserver etcd Endpoint ==="
echo ""

FAILED=0
MANIFEST="/etc/kubernetes/manifests/kube-apiserver.yaml"

echo -n "CHECK 1: API server is reachable (kubectl get nodes)... "
if kubectl get nodes --request-timeout=10s &>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: manifest etcd-servers points at 2379 (not 2380)... "
if [ -f "$MANIFEST" ]; then
  ETCD_LINE=$(sudo grep 'etcd-servers' "$MANIFEST" 2>/dev/null)
  if echo "$ETCD_LINE" | grep -q '2379' && ! echo "$ETCD_LINE" | grep -q '2380'; then
    echo "PASS"
  else
    echo "FAIL (etcd-servers line: $ETCD_LINE)"
    FAILED=$((FAILED + 1))
  fi
else
  echo "SKIP (manifest not found; non-kubeadm environment)"
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
