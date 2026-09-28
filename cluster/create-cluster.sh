#!/usr/bin/env bash
set -euo pipefail

echo "Verifying kubeadm cluster is ready for CKA labs..."
if ! kubectl get nodes &>/dev/null; then
  echo "ERROR: kubectl cannot reach the cluster."
  echo "Make sure you're on the controlplane node of a Killercoda Kubernetes playground (2 nodes)."
  exit 1
fi

echo ""
kubectl get nodes -o wide

# Verify 2-node cluster
NODE_COUNT=$(kubectl get nodes --no-headers | wc -l)
if [ "$NODE_COUNT" -lt 2 ]; then
  echo ""
  echo "⚠ Only $NODE_COUNT node(s) detected. Expected 2 (controlplane + node01)."
  echo "  Some scenarios may still work on a single-node cluster."
fi

# Ensure CNI is running (Killercoda has Calico by default)
echo ""
if kubectl get pods -n kube-system -l k8s-app=calico-node 2>/dev/null | grep -q Running; then
  echo "✓ Calico CNI is running (NetworkPolicies enforced)"
elif kubectl get pods -n calico-system 2>/dev/null | grep -q Running; then
  echo "✓ Calico CNI is running (NetworkPolicies enforced)"
elif kubectl get pods -n kube-system 2>/dev/null | grep -q flannel; then
  echo "✓ Flannel CNI is running"
  echo "⚠ Note: Flannel does not enforce NetworkPolicies. Scenario 13 may not work as expected."
else
  echo "⚠ Calico not detected. NetworkPolicy scenarios (08, 13) need a CNI that enforces policies."
  echo "  Scenario 08 walks you through installing one."
fi

echo ""
echo "═══════════════════════════════════════════════════"
echo "  Cluster ready! Run ../cka.sh to start studying"
echo "═══════════════════════════════════════════════════"
echo ""
echo "Nodes:"
echo "  controlplane — you are here"
echo "  node01       — ssh node01"
echo ""
echo "Tips:"
echo "  - Use kubectl explain <resource> for field discovery"
echo "  - kubernetes.io/docs is allowed in the exam"
echo "  - Practice each scenario until you can do it quickly and cleanly"
echo "  - Several CKA scenarios touch the control plane / nodes directly (etcd, cri-dockerd)"
