#!/bin/bash

echo "=== Checking Scenario 03: Add a Sidecar Container to WordPress ==="
echo ""

FAILED=0

echo -n "CHECK 1: Deployment 'wordpress' has a container named 'sidecar'... "
CONTAINERS=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.containers[*].name}' 2>/dev/null)
if echo "$CONTAINERS" | grep -qw "sidecar"; then
  echo "PASS"
else
  echo "FAIL (containers=$CONTAINERS)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: 'sidecar' container uses image busybox:stable... "
IMG=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].image}' 2>/dev/null)
if [ "$IMG" = "busybox:stable" ]; then
  echo "PASS"
else
  echo "FAIL (image=$IMG)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 3: 'wordpress' container mounts a volume at /var/log... "
WP_MOUNT=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.containers[?(@.name=="wordpress")].volumeMounts[?(@.mountPath=="/var/log")].name}' 2>/dev/null)
if [ -n "$WP_MOUNT" ]; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 4: 'sidecar' container mounts a volume at /var/log... "
SC_MOUNT=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].volumeMounts[?(@.mountPath=="/var/log")].name}' 2>/dev/null)
if [ -n "$SC_MOUNT" ]; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 5: both containers share the SAME volume at /var/log... "
if [ -n "$WP_MOUNT" ] && [ "$WP_MOUNT" = "$SC_MOUNT" ]; then
  echo "PASS"
else
  echo "FAIL (wordpress=$WP_MOUNT sidecar=$SC_MOUNT)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 6: Deployment rollout is successful... "
if kubectl rollout status deploy wordpress -n default --timeout=90s &>/dev/null; then
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
