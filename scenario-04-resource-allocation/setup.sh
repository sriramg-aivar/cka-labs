#!/bin/bash
set -e

echo "=== Setting up Scenario 04: Resource Requests & Limits ==="

# Clean any prior state
kubectl delete deployment wordpress -n default --ignore-not-found >/dev/null 2>&1 || true

echo "Creating 'wordpress' Deployment (3 replicas, initContainer init-setup)..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  namespace: default
  labels:
    app: wordpress
spec:
  replicas: 3
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      initContainers:
      - name: init-setup
        image: busybox
        command:
        - /bin/sh
        - -c
        - "echo Preparing... && sleep 5"
      containers:
      - name: wordpress
        image: wordpress:6.2-apache
        ports:
        - containerPort: 80
EOF

echo "Waiting for deployment to be ready..."
kubectl rollout status deploy wordpress -n default --timeout=120s || true

echo ""
echo "=== Setup complete ==="
echo "  - Deployment 'wordpress' (3 replicas)"
echo "  - initContainer 'init-setup' (busybox), main container wordpress:6.2-apache"
echo "  - No resource requests/limits set yet"
echo ""
echo "See TASK.md for full instructions."
