#!/bin/bash

echo "=== Checking Scenario 16: NodePort Service ==="
echo ""

FAILED=0
NS="relative"

echo -n "CHECK 1: deployment container has port named 'http' containerPort 80 TCP... "
PORT_NAME=$(kubectl -n "$NS" get deploy nodeport-deployment -o jsonpath='{.spec.template.spec.containers[0].ports[0].name}' 2>/dev/null)
PORT_NUM=$(kubectl -n "$NS" get deploy nodeport-deployment -o jsonpath='{.spec.template.spec.containers[0].ports[0].containerPort}' 2>/dev/null)
PORT_PROTO=$(kubectl -n "$NS" get deploy nodeport-deployment -o jsonpath='{.spec.template.spec.containers[0].ports[0].protocol}' 2>/dev/null)
if [ "$PORT_NAME" = "http" ] && [ "$PORT_NUM" = "80" ] && { [ "$PORT_PROTO" = "TCP" ] || [ -z "$PORT_PROTO" ]; }; then
  echo "PASS"
else
  echo "FAIL (name=$PORT_NAME port=$PORT_NUM proto=$PORT_PROTO)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: service 'nodeport-service' is type NodePort... "
SVC_TYPE=$(kubectl -n "$NS" get svc nodeport-service -o jsonpath='{.spec.type}' 2>/dev/null)
if [ "$SVC_TYPE" = "NodePort" ]; then
  echo "PASS"
else
  echo "FAIL (type=$SVC_TYPE)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 3: service port 80 with nodePort 30080... "
SVC_PORT=$(kubectl -n "$NS" get svc nodeport-service -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
NODE_PORT=$(kubectl -n "$NS" get svc nodeport-service -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)
if [ "$SVC_PORT" = "80" ] && [ "$NODE_PORT" = "30080" ]; then
  echo "PASS"
else
  echo "FAIL (port=$SVC_PORT nodePort=$NODE_PORT)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 4: service selector matches app=nodeport-deployment... "
SEL=$(kubectl -n "$NS" get svc nodeport-service -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$SEL" = "nodeport-deployment" ]; then
  echo "PASS"
else
  echo "FAIL (selector app=$SEL)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 5: service endpoints are populated... "
EP=$(kubectl -n "$NS" get endpoints nodeport-service -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null)
if [ -n "$EP" ]; then
  echo "PASS"
else
  echo "FAIL (no endpoints)"
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
