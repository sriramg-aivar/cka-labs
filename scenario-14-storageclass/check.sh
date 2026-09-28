#!/bin/bash

echo "=== Checking Scenario 14: Default StorageClass ==="
echo ""

FAILED=0

echo -n "CHECK 1: StorageClass 'local-storage' exists... "
if kubectl get sc local-storage &>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: provisioner is rancher.io/local-path... "
PROV=$(kubectl get sc local-storage -o jsonpath='{.provisioner}' 2>/dev/null)
if [ "$PROV" = "rancher.io/local-path" ]; then
  echo "PASS"
else
  echo "FAIL (provisioner=$PROV)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 3: volumeBindingMode is WaitForFirstConsumer... "
VBM=$(kubectl get sc local-storage -o jsonpath='{.volumeBindingMode}' 2>/dev/null)
if [ "$VBM" = "WaitForFirstConsumer" ]; then
  echo "PASS"
else
  echo "FAIL (volumeBindingMode=$VBM)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 4: local-storage has is-default-class=true... "
DEF=$(kubectl get sc local-storage -o jsonpath='{.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}' 2>/dev/null)
if [ "$DEF" = "true" ]; then
  echo "PASS"
else
  echo "FAIL (is-default-class=$DEF)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 5: exactly one default StorageClass exists... "
COUNT=$(kubectl get sc -o jsonpath='{range .items[*]}{.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}{"\n"}{end}' 2>/dev/null | grep -c '^true$')
if [ "$COUNT" = "1" ]; then
  echo "PASS"
else
  echo "FAIL (default count=$COUNT)"
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
