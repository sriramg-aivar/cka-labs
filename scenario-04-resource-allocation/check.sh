#!/bin/bash

echo "=== Checking Scenario 04: Resource Requests & Limits ==="
echo ""

FAILED=0

# Gather main container resources
MC_RC=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
MC_RM=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}' 2>/dev/null)
MC_LC=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}' 2>/dev/null)
MC_LM=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}' 2>/dev/null)

# Gather init container resources
IC_RC=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.initContainers[0].resources.requests.cpu}' 2>/dev/null)
IC_RM=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.initContainers[0].resources.requests.memory}' 2>/dev/null)
IC_LC=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.initContainers[0].resources.limits.cpu}' 2>/dev/null)
IC_LM=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.initContainers[0].resources.limits.memory}' 2>/dev/null)

echo -n "CHECK 1: main container has all requests/limits (cpu+memory) set... "
if [ -n "$MC_RC" ] && [ -n "$MC_RM" ] && [ -n "$MC_LC" ] && [ -n "$MC_LM" ]; then
  echo "PASS"
else
  echo "FAIL (req=$MC_RC/$MC_RM lim=$MC_LC/$MC_LM)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: init container has all requests/limits (cpu+memory) set... "
if [ -n "$IC_RC" ] && [ -n "$IC_RM" ] && [ -n "$IC_LC" ] && [ -n "$IC_LM" ]; then
  echo "PASS"
else
  echo "FAIL (req=$IC_RC/$IC_RM lim=$IC_LC/$IC_LM)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 3: init and main requests/limits are EQUAL to each other... "
if [ "$MC_RC" = "$IC_RC" ] && [ "$MC_RM" = "$IC_RM" ] && [ "$MC_LC" = "$IC_LC" ] && [ "$MC_LM" = "$IC_LM" ]; then
  echo "PASS"
else
  echo "FAIL (main req=$MC_RC/$MC_RM lim=$MC_LC/$MC_LM vs init req=$IC_RC/$IC_RM lim=$IC_LC/$IC_LM)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 4: Deployment has 3 replicas... "
REPLICAS=$(kubectl get deploy wordpress -n default -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$REPLICAS" = "3" ]; then
  echo "PASS"
else
  echo "FAIL (replicas=$REPLICAS)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 5: Deployment rollout is successful... "
if kubectl rollout status deploy wordpress -n default --timeout=120s &>/dev/null; then
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
