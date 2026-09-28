#!/bin/bash

echo "=== Checking Scenario 08: Install a CNI with NetworkPolicy Support ==="
echo ""

FAILED=0

echo -n "CHECK 1: A NetworkPolicy-capable CNI (Calico) is present and running... "
CALICO_FOUND=""
for NS in kube-system calico-system tigera-operator; do
  RUNNING=$(kubectl get pods -n "$NS" 2>/dev/null | grep -iE 'calico|tigera' | grep -i 'Running')
  if [ -n "$RUNNING" ]; then
    CALICO_FOUND="yes"
    break
  fi
done
if [ -n "$CALICO_FOUND" ]; then
  echo "PASS"
else
  echo "FAIL"
  echo "    GUIDANCE: Install Calico (it enforces NetworkPolicy; Flannel does not):"
  echo "    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: All nodes are Ready... "
NOT_READY=$(kubectl get nodes --no-headers 2>/dev/null | awk '{print $2}' | grep -v '^Ready$')
TOTAL=$(kubectl get nodes --no-headers 2>/dev/null | wc -l | tr -d ' ')
if [ "$TOTAL" != "0" ] && [ -z "$NOT_READY" ]; then
  echo "PASS"
else
  echo "FAIL (some nodes not Ready or no nodes found)"
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
