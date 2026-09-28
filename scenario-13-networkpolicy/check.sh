#!/bin/bash

echo "=== Checking Scenario 13: Choose the Least-Permissive NetworkPolicy ==="
echo ""

FAILED=0

# Find any NetworkPolicy in ns backend that selects app=backend and whose ingress
# rule includes BOTH a namespaceSelector name=frontend AND a podSelector app=frontend
# on port 80, with no over-broad extra 'from' peers (no ipBlock, no empty rule).
MATCH=0
NPS=$(kubectl get networkpolicy -n backend -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null)

echo -n "CHECK 1: a least-permissive NetworkPolicy is applied in ns backend... "
for NP in $NPS; do
  SEL=$(kubectl get networkpolicy "$NP" -n backend -o jsonpath='{.spec.podSelector.matchLabels.app}' 2>/dev/null)
  [ "$SEL" != "backend" ] && continue

  NS_SEL=$(kubectl get networkpolicy "$NP" -n backend -o jsonpath='{.spec.ingress[0].from[0].namespaceSelector.matchLabels.name}' 2>/dev/null)
  POD_SEL=$(kubectl get networkpolicy "$NP" -n backend -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}' 2>/dev/null)
  PORT=$(kubectl get networkpolicy "$NP" -n backend -o jsonpath='{.spec.ingress[0].ports[0].port}' 2>/dev/null)

  # Reject over-broad rules: more than one 'from' peer, or an ipBlock present
  FROM_COUNT=$(kubectl get networkpolicy "$NP" -n backend -o jsonpath='{.spec.ingress[0].from[*]}' 2>/dev/null | grep -o 'map\[' | wc -l | tr -d ' ')
  IPBLOCK=$(kubectl get networkpolicy "$NP" -n backend -o jsonpath='{.spec.ingress[0].from[*].ipBlock.cidr}' 2>/dev/null)

  if [ "$NS_SEL" = "frontend" ] && [ "$POD_SEL" = "frontend" ] && [ "$PORT" = "80" ] && [ -z "$IPBLOCK" ]; then
    MATCH=1
    MATCH_NAME="$NP"
    break
  fi
done

if [ "$MATCH" = "1" ]; then
  echo "PASS (policy '$MATCH_NAME')"
else
  echo "FAIL (no policy with namespaceSelector name=frontend + podSelector app=frontend on port 80, and no ipBlock)"
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
