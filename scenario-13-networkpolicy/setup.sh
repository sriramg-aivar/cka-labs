#!/bin/bash
set -e

echo "=== Setting up Scenario 13: Choose the Least-Permissive NetworkPolicy ==="

# Namespaces
kubectl create ns frontend --dry-run=client -o yaml | kubectl apply -f -
kubectl create ns backend --dry-run=client -o yaml | kubectl apply -f -

# IMPORTANT: label the frontend namespace so namespaceSelector name=frontend works
kubectl label ns frontend name=frontend --overwrite

# Clean any prior state
kubectl delete deployment backend -n backend --ignore-not-found >/dev/null 2>&1 || true
kubectl delete service backend-service -n backend --ignore-not-found >/dev/null 2>&1 || true
kubectl delete deployment frontend -n frontend --ignore-not-found >/dev/null 2>&1 || true

echo "Creating backend deployment + service in ns backend..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: backend
  labels:
    app: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
  namespace: backend
spec:
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 80
EOF

echo "Creating frontend deployment in ns frontend..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: frontend
  labels:
    app: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: curl
        image: curlimages/curl:8.8.0
        command: ["sleep", "3600"]
EOF

echo "Writing candidate NetworkPolicy files to /root/network-policies ..."
mkdir -p /root/network-policies

# policy-1: allow ALL ingress (too open)
cat <<'EOF' > /root/network-policies/network-policy-1.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-allow
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - {}
EOF

# policy-2: frontend namespace + broad ipBlock (too open)
cat <<'EOF' > /root/network-policies/network-policy-2.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-allow
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: frontend
    - ipBlock:
        cidr: 172.16.0.0/16
    ports:
    - protocol: TCP
      port: 80
EOF

# policy-3: only frontend ns + frontend pod on port 80 (least permissive - CORRECT)
cat <<'EOF' > /root/network-policies/network-policy-3.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-allow
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: frontend
      podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 80
EOF

echo ""
echo "=== Setup complete ==="
echo "  - Namespaces: frontend (labeled name=frontend), backend"
echo "  - backend: Deployment 'backend' (nginx) + Service 'backend-service' (port 80)"
echo "  - frontend: Deployment 'frontend' (curl sleeping)"
echo "  - Candidate policies: /root/network-policies/network-policy-{1,2,3}.yaml"
echo ""
echo "See TASK.md for full instructions."
