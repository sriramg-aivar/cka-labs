#!/bin/bash
set -e

echo "=== Setting up Scenario 03: Add a Sidecar Container to WordPress ==="

# Clean any prior state
kubectl delete deployment wordpress -n default --ignore-not-found >/dev/null 2>&1 || true
kubectl delete service wordpress -n default --ignore-not-found >/dev/null 2>&1 || true

echo "Creating 'wordpress' Deployment and Service..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  namespace: default
  labels:
    app: wordpress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
      - name: wordpress
        image: wordpress:php8.2-apache
        command:
        - /bin/sh
        - -c
        - "while true; do echo \"\$(date) wordpress log entry\" >> /var/log/wordpress.log; sleep 5; done"
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: wordpress
  namespace: default
spec:
  selector:
    app: wordpress
  ports:
  - port: 80
    targetPort: 80
EOF

echo "Waiting for deployment to be ready..."
kubectl rollout status deploy wordpress -n default --timeout=90s || true

echo ""
echo "=== Setup complete ==="
echo "  - Deployment 'wordpress' (wordpress:php8.2-apache) writing to /var/log/wordpress.log"
echo "  - Service 'wordpress' on port 80"
echo ""
echo "See TASK.md for full instructions."
