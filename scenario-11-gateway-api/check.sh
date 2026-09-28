#!/bin/bash

echo "=== Checking Scenario 11: Migrate Ingress to Gateway API ==="
echo ""

FAILED=0

echo -n "CHECK 1: Gateway 'web-gateway' exists... "
if kubectl get gateway web-gateway &>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: Gateway uses gatewayClassName 'nginx-class'... "
GC=$(kubectl get gateway web-gateway -o jsonpath='{.spec.gatewayClassName}' 2>/dev/null)
if [ "$GC" = "nginx-class" ]; then
  echo "PASS"
else
  echo "FAIL (gatewayClassName=$GC)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 3: Gateway has a listener hostname gateway.web.k8s.local using secret web-tls... "
HOST=$(kubectl get gateway web-gateway -o jsonpath='{range .spec.listeners[*]}{.hostname}{"\n"}{end}' 2>/dev/null | grep -x 'gateway.web.k8s.local')
CERT=$(kubectl get gateway web-gateway -o jsonpath='{range .spec.listeners[*]}{range .tls.certificateRefs[*]}{.name}{"\n"}{end}{end}' 2>/dev/null | grep -x 'web-tls')
if [ -n "$HOST" ] && [ -n "$CERT" ]; then
  echo "PASS"
else
  echo "FAIL (hostname='$HOST' certRef='$CERT')"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 4: HTTPRoute 'web-route' exists... "
if kubectl get httproute web-route &>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 5: HTTPRoute 'web-route' references backend web-service... "
BE=$(kubectl get httproute web-route -o jsonpath='{range .spec.rules[*].backendRefs[*]}{.name}{"\n"}{end}' 2>/dev/null | grep -x 'web-service')
if [ -n "$BE" ]; then
  echo "PASS"
else
  echo "FAIL (backendRef=$BE)"
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
