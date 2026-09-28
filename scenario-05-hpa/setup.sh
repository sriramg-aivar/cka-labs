#!/bin/bash
set -e

echo "=== Setting up Scenario 05: HorizontalPodAutoscaler ==="

# Clean any prior state
kubectl delete hpa apache-server -n autoscale --ignore-not-found >/dev/null 2>&1 || true
kubectl delete service apache-deployment -n autoscale --ignore-not-found >/dev/null 2>&1 || true
kubectl delete deployment apache-deployment -n autoscale --ignore-not-found >/dev/null 2>&1 || true

# Create namespace
kubectl create ns autoscale --dry-run=client -o yaml | kubectl apply -f -

echo "Installing metrics-server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml || true

echo "Patching metrics-server with --kubelet-insecure-tls (ignore errors)..."
kubectl patch deployment metrics-server -n kube-system --type='json' \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]' >/dev/null 2>&1 || true

echo "Creating 'apache-deployment' Deployment and Service..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-deployment
  namespace: autoscale
  labels:
    app: apache
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apache
  template:
    metadata:
      labels:
        app: apache
    spec:
      containers:
      - name: httpd
        image: httpd
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
          limits:
            cpu: 200m
---
apiVersion: v1
kind: Service
metadata:
  name: apache-deployment
  namespace: autoscale
spec:
  selector:
    app: apache
  ports:
  - port: 80
    targetPort: 80
EOF

echo "Waiting for deployment to be ready..."
kubectl rollout status deploy apache-deployment -n autoscale --timeout=90s || true

echo ""
echo "=== Setup complete ==="
echo "  - Namespace 'autoscale'"
echo "  - Deployment 'apache-deployment' (httpd, cpu req 100m / lim 200m)"
echo "  - Service 'apache-deployment' on port 80"
echo "  - metrics-server installed (may take a moment to report metrics)"
echo ""
echo "See TASK.md for full instructions."
