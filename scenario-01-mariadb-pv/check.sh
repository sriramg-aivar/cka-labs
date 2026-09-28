#!/bin/bash

echo "=== Checking Scenario 01: Recover MariaDB Using an Existing PV ==="
echo ""

FAILED=0

echo -n "CHECK 1: PVC 'mariadb' exists in namespace mariadb... "
if kubectl get pvc mariadb -n mariadb &>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: PVC 'mariadb' is Bound... "
if [ "$(kubectl get pvc mariadb -n mariadb -o jsonpath='{.status.phase}' 2>/dev/null)" = "Bound" ]; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 3: PVC requests 250Mi and ReadWriteOnce... "
REQ=$(kubectl get pvc mariadb -n mariadb -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null)
MODE=$(kubectl get pvc mariadb -n mariadb -o jsonpath='{.spec.accessModes[0]}' 2>/dev/null)
if [ "$REQ" = "250Mi" ] && [ "$MODE" = "ReadWriteOnce" ]; then
  echo "PASS"
else
  echo "FAIL (storage=$REQ mode=$MODE)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 4: PV 'mariadb-pv' is Bound to the mariadb PVC... "
BOUND_PVC=$(kubectl get pv mariadb-pv -o jsonpath='{.spec.claimRef.name}' 2>/dev/null)
PV_PHASE=$(kubectl get pv mariadb-pv -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$BOUND_PVC" = "mariadb" ] && [ "$PV_PHASE" = "Bound" ]; then
  echo "PASS"
else
  echo "FAIL (claim=$BOUND_PVC phase=$PV_PHASE)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 5: Deployment 'mariadb' rollout is successful... "
if kubectl rollout status deploy mariadb -n mariadb --timeout=60s &>/dev/null; then
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
