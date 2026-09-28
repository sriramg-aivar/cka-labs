#!/bin/bash
set -e

echo "=== Setting up Scenario 07: PriorityClass ==="

kubectl create ns priority --dry-run=client -o yaml | kubectl apply -f -

# Clean any prior state
kubectl delete deployment busybox-logger -n priority --ignore-not-found >/dev/null 2>&1 || true
kubectl delete priorityclass high-priority --ignore-not-found >/dev/null 2>&1 || true
kubectl delete priorityclass user-critical --ignore-not-found >/dev/null 2>&1 || true

echo "Creating user-defined PriorityClass 'user-critical' (value 1000)..."
kubectl apply -f - <<EOF
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: user-critical
value: 1000
globalDefault: false
description: "User-defined critical priority class"
EOF

echo "Creating Deployment 'busybox-logger' in namespace priority..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox-logger
  namespace: priority
spec:
  replicas: 1
  selector:
    matchLabels:
      app: busybox-logger
  template:
    metadata:
      labels:
        app: busybox-logger
    spec:
      containers:
      - name: busybox
        image: busybox:1.36
        command:
        - sh
        - -c
        - 'while true; do echo "logging $(date)"; sleep 5; done'
EOF

kubectl rollout status deploy busybox-logger -n priority --timeout=60s || true

echo ""
echo "=== Setup complete ==="
echo "  - Namespace: priority"
echo "  - PriorityClass 'user-critical' (value 1000)"
echo "  - Deployment 'busybox-logger' running"
echo ""
echo "See TASK.md for full instructions."
