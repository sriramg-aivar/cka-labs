#!/bin/bash

echo "=== Checking Scenario 12: Expose Deployment via Ingress ==="
echo ""

FAILED=0

echo -n "CHECK 1: Service 'echo-service' exists in echo-sound... "
if kubectl get svc echo-service -n echo-sound &>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: Service is type NodePort on port 8080... "
STYPE=$(kubectl get svc echo-service -n echo-sound -o jsonpath='{.spec.type}' 2>/dev/null)
SPORT=$(kubectl get svc echo-service -n echo-sound -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
if [ "$STYPE" = "NodePort" ] && [ "$SPORT" = "8080" ]; then
  echo "PASS"
else
  echo "FAIL (type=$STYPE port=$SPORT)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 3: Ingress 'echo' exists in echo-sound... "
if kubectl get ingress echo -n echo-sound &>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 4: Ingress rule host=example.org path=/echo -> echo-service:8080... "
HOST=$(kubectl get ingress echo -n echo-sound -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
PATH_VAL=$(kubectl get ingress echo -n echo-sound -o jsonpath='{.spec.rules[0].http.paths[0].path}' 2>/dev/null)
SVC=$(kubectl get ingress echo -n echo-sound -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null)
BPORT=$(kubectl get ingress echo -n echo-sound -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' 2>/dev/null)
if [ "$HOST" = "example.org" ] && [ "$PATH_VAL" = "/echo" ] && [ "$SVC" = "echo-service" ] && [ "$BPORT" = "8080" ]; then
  echo "PASS"
else
  echo "FAIL (host=$HOST path=$PATH_VAL svc=$SVC port=$BPORT)"
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
