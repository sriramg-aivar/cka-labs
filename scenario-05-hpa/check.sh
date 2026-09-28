#!/bin/bash

echo "=== Checking Scenario 05: HorizontalPodAutoscaler ==="
echo ""

FAILED=0

echo -n "CHECK 1: HPA 'apache-server' exists in namespace autoscale... "
if kubectl get hpa apache-server -n autoscale &>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: scaleTargetRef is Deployment/apache-deployment... "
REF_NAME=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.scaleTargetRef.name}' 2>/dev/null)
REF_KIND=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.scaleTargetRef.kind}' 2>/dev/null)
if [ "$REF_NAME" = "apache-deployment" ] && [ "$REF_KIND" = "Deployment" ]; then
  echo "PASS"
else
  echo "FAIL (kind=$REF_KIND name=$REF_NAME)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 3: minReplicas=1 and maxReplicas=4... "
MIN=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.minReplicas}' 2>/dev/null)
MAX=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.maxReplicas}' 2>/dev/null)
if [ "$MIN" = "1" ] && [ "$MAX" = "4" ]; then
  echo "PASS"
else
  echo "FAIL (min=$MIN max=$MAX)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 4: CPU target averageUtilization=50... "
UTIL=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.metrics[?(@.resource.name=="cpu")].resource.target.averageUtilization}' 2>/dev/null)
if [ "$UTIL" = "50" ]; then
  echo "PASS"
else
  echo "FAIL (averageUtilization=$UTIL)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 5: scaleDown stabilizationWindowSeconds=30... "
WINDOW=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.behavior.scaleDown.stabilizationWindowSeconds}' 2>/dev/null)
if [ "$WINDOW" = "30" ]; then
  echo "PASS"
else
  echo "FAIL (stabilizationWindowSeconds=$WINDOW)"
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
