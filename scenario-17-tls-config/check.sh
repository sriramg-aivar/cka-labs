#!/bin/bash

echo "=== Checking Scenario 17: Restrict nginx to TLSv1.3 ==="
echo ""

FAILED=0
NS="nginx-static"

echo -n "CHECK 1: ConfigMap 'nginx-config' ssl_protocols contains TLSv1.3... "
SSL_LINE=$(kubectl -n "$NS" get configmap nginx-config -o jsonpath='{.data.nginx\.conf}' 2>/dev/null | grep 'ssl_protocols')
if echo "$SSL_LINE" | grep -q 'TLSv1.3'; then
  echo "PASS"
else
  echo "FAIL (ssl_protocols: $SSL_LINE)"
  FAILED=$((FAILED + 1))
fi

echo -n "CHECK 2: ConfigMap 'nginx-config' ssl_protocols does NOT contain TLSv1.2... "
if echo "$SSL_LINE" | grep -q 'TLSv1.2'; then
  echo "FAIL (TLSv1.2 still present: $SSL_LINE)"
  FAILED=$((FAILED + 1))
else
  echo "PASS"
fi

echo -n "CHECK 3: deployment 'nginx-static' rollout is successful... "
if kubectl -n "$NS" rollout status deploy nginx-static --timeout=60s &>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  FAILED=$((FAILED + 1))
fi

# Optional informational check (environment-dependent, not counted).
echo -n "INFO: TLSv1.2 handshake should be refused via curl... "
if command -v curl >/dev/null 2>&1 && kubectl -n "$NS" get svc nginx-static &>/dev/null; then
  if curl -sk --tls-max 1.2 https://ckaquestion.k8s.local >/dev/null 2>&1; then
    echo "TLSv1.2 succeeded (unexpected if /etc/hosts is set)"
  else
    echo "TLSv1.2 refused or host not resolvable (expected)"
  fi
else
  echo "SKIP (curl or service unavailable)"
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
