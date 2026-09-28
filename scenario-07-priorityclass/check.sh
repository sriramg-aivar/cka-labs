#!/bin/bash

echo "=== Checking Scenario 07: PriorityClass ==="
echo ""

FAILED=0

echo -n "CHECK 1: PriorityClass 'high-priority' exists... "
if kubectl get priorityclass high-priority &>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: PriorityClass 'high-priority' value is 999... "
VAL=$(kubectl get priorityclass high-priority -o jsonpath='{.value}' 2>/dev/null)
if [ "$VAL" = "999" ]; then
  echo "PASS"
else
  echo "FAIL (value=$VAL)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 3: Deployment busybox-logger uses priorityClassName=high-priority... "
PC=$(kubectl get deploy busybox-logger -n priority -o jsonpath='{.spec.template.spec.priorityClassName}' 2>/dev/null)
if [ "$PC" = "high-priority" ]; then
  echo "PASS"
else
  echo "FAIL (priorityClassName=$PC)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 4: Deployment busybox-logger rollout is successful... "
if kubectl rollout status deploy busybox-logger -n priority --timeout=60s &>/dev/null; then
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
