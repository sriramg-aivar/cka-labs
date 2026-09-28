#!/bin/bash

echo "=== Checking Scenario 10: Taints & Tolerations ==="
echo ""

FAILED=0

echo -n "CHECK 1: node01 has taint PERMISSION=granted:NoSchedule... "
TAINT_KEY=$(kubectl get node node01 -o jsonpath='{range .spec.taints[?(@.key=="PERMISSION")]}{.key}={.value}:{.effect}{end}' 2>/dev/null)
if [ "$TAINT_KEY" = "PERMISSION=granted:NoSchedule" ]; then
  echo "PASS"
else
  echo "FAIL (found: '$TAINT_KEY')"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: a pod tolerating key PERMISSION is Running on node01... "
FOUND=0
PODS=$(kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}/{.metadata.name}{"\n"}{end}' 2>/dev/null)
for entry in $PODS; do
  NS="${entry%%/*}"
  NAME="${entry##*/}"
  TOL=$(kubectl get pod "$NAME" -n "$NS" -o jsonpath='{range .spec.tolerations[?(@.key=="PERMISSION")]}{.key}{end}' 2>/dev/null)
  NODE=$(kubectl get pod "$NAME" -n "$NS" -o jsonpath='{.spec.nodeName}' 2>/dev/null)
  PHASE=$(kubectl get pod "$NAME" -n "$NS" -o jsonpath='{.status.phase}' 2>/dev/null)
  if [ "$TOL" = "PERMISSION" ] && [ "$NODE" = "node01" ] && [ "$PHASE" = "Running" ]; then
    FOUND=1
    break
  fi
done
if [ "$FOUND" = "1" ]; then
  echo "PASS"
else
  echo "FAIL (no Running pod with a PERMISSION toleration on node01)"
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
