#!/bin/bash
set -e

echo "=== Setting up Scenario 11: Migrate Ingress to Gateway API ==="

# Install Gateway API CRDs (tolerate failure if already present / offline)
echo "Installing Gateway API CRDs (v1.1.0)..."
kubectl apply -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.1.0" || \
  echo "WARN: could not apply Gateway API CRDs (may already exist or no network)"

# Clean any prior state
kubectl delete ingress web --ignore-not-found >/dev/null 2>&1 || true
kubectl delete service web-service --ignore-not-found >/dev/null 2>&1 || true
kubectl delete deployment web-deployment --ignore-not-found >/dev/null 2>&1 || true
kubectl delete secret web-tls --ignore-not-found >/dev/null 2>&1 || true

echo "Creating web-deployment (nginx, 2 replicas, port 80)..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
  labels:
    app: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF

echo "Creating web-service (port 80)..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
EOF

echo "Creating self-signed TLS secret 'web-tls'..."
TLS_DIR="$(mktemp -d)"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "${TLS_DIR}/tls.key" -out "${TLS_DIR}/tls.crt" \
  -subj "/CN=gateway.web.k8s.local/O=gateway.web.k8s.local" >/dev/null 2>&1
kubectl create secret tls web-tls \
  --cert="${TLS_DIR}/tls.crt" --key="${TLS_DIR}/tls.key" \
  --dry-run=client -o yaml | kubectl apply -f -
rm -rf "${TLS_DIR}"

echo "Creating the existing Ingress 'web'..."
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web
spec:
  tls:
  - hosts:
    - gateway.web.k8s.local
    secretName: web-tls
  rules:
  - host: gateway.web.k8s.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
EOF

echo "Creating GatewayClass 'nginx-class'..."
kubectl apply -f - <<EOF || echo "WARN: GatewayClass could not be created (CRDs missing?)"
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nginx-class
spec:
  controllerName: example.net/nginx-gateway-controller
EOF

echo ""
echo "=== Setup complete ==="
echo "  - Deployment: web-deployment (2x nginx)"
echo "  - Service: web-service (port 80)"
echo "  - Secret: web-tls (self-signed, CN=gateway.web.k8s.local)"
echo "  - Ingress: web (HTTPS host gateway.web.k8s.local)"
echo "  - GatewayClass: nginx-class"
echo ""
echo "See TASK.md for full instructions."
