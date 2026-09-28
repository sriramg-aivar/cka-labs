#!/bin/bash

echo "=== Checking Scenario 09: Set up cri-dockerd ==="
echo ""

FAILED=0

echo -n "CHECK 1: cri-docker.service is active... "
if command -v systemctl >/dev/null 2>&1; then
  if [ "$(systemctl is-active cri-docker.service 2>/dev/null)" = "active" ]; then
    echo "PASS"
  else
    echo "FAIL"
    FAILED=$((FAILED + 1))
  fi
else
  echo "FAIL (systemctl not available on this host)"
  FAILED=$((FAILED + 1))
fi

check_sysctl() {
  local key="$1"
  local expected="$2"
  echo -n "CHECK: sysctl $key = $expected... "
  if command -v sysctl >/dev/null 2>&1; then
    local actual
    actual=$(sysctl -n "$key" 2>/dev/null)
    if [ "$actual" = "$expected" ]; then
      echo "PASS"
    else
      echo "FAIL (got '$actual')"
      FAILED=$((FAILED + 1))
    fi
  else
    echo "FAIL (sysctl not available on this host)"
    FAILED=$((FAILED + 1))
  fi
}

check_sysctl net.bridge.bridge-nf-call-iptables 1
check_sysctl net.ipv6.conf.all.forwarding 1
check_sysctl net.ipv4.ip_forward 1
check_sysctl net.netfilter.nf_conntrack_max 131072

echo ""
echo "=== Results ==="
if [ $FAILED -eq 0 ]; then
  echo "ALL CHECKS PASSED ✅"
  exit 0
else
  echo "$FAILED CHECK(S) FAILED ❌"
  exit 1
fi
