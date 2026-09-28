#!/bin/bash

echo "=== Checking Scenario 06: Extract CRD Documentation ==="
echo ""

FAILED=0

echo -n "CHECK 1: /root/resources.yaml exists... "
if [ -f /root/resources.yaml ]; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: /root/resources.yaml mentions 'cert-manager'... "
if [ -f /root/resources.yaml ] && grep -q "cert-manager" /root/resources.yaml; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 3: /root/subject.yaml exists and is non-empty... "
if [ -s /root/subject.yaml ]; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 4: /root/subject.yaml mentions 'subject'... "
if [ -f /root/subject.yaml ] && grep -qi "subject" /root/subject.yaml; then
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
