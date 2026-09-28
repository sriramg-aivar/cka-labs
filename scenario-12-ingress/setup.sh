#!/bin/bash
set -e

echo "=== Setting up Scenario 12: Expose Deployment via Ingress ==="

kubectl create ns echo-sound --dry-run=client -o yaml | kubectl apply -f -

# Clean any prior state
kubectl delete ingress echo -n echo-sound --ignore-not-found >/dev/null 2>&1 || true
kubectl delete service echo-service -n echo-sound --ignore-not-found >/dev/null 2>&1 || true
kubectl delete deployment echo -n echo-sound --ignore-not-found >/dev/null 2>&1 || true

echo "Creating Deployment 'echo' in namespace echo-sound..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo
  namespace: echo-sound
  labels:
    app: echo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echo
  template:
    metadata:
      labels:
        app: echo
    spec:
      containers:
      - name: echo
        image: gcr.io/google_containers/echoserver:1.10
        ports:
        - containerPort: 8080
EOF

echo ""
echo "=== Setup complete ==="
echo "  - Namespace: echo-sound"
echo "  - Deployment: echo (echoserver:1.10, containerPort 8080)"
echo ""
echo "See TASK.md for full instructions."
