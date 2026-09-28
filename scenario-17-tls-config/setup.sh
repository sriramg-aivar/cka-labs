#!/bin/bash
set -e

echo "=== Setting up Scenario 17: Restrict nginx to TLSv1.3 ==="

NS="nginx-static"

kubectl create ns "$NS" --dry-run=client -o yaml | kubectl apply -f -

# Clean any prior state
kubectl -n "$NS" delete deployment nginx-static --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete service nginx-static --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete configmap nginx-config --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete secret nginx-tls --ignore-not-found >/dev/null 2>&1 || true

echo "Generating a self-signed TLS certificate (CN=ckaquestion.k8s.local)..."
TLSDIR=$(mktemp -d)
openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
  -keyout "${TLSDIR}/tls.key" -out "${TLSDIR}/tls.crt" \
  -subj "/CN=ckaquestion.k8s.local" >/dev/null 2>&1

kubectl -n "$NS" create secret tls nginx-tls \
  --cert="${TLSDIR}/tls.crt" --key="${TLSDIR}/tls.key"

rm -rf "$TLSDIR"

echo "Creating ConfigMap 'nginx-config' (supports TLSv1.2 AND TLSv1.3)..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
  namespace: nginx-static
data:
  nginx.conf: |
    events {}
    http {
      server {
        listen 443 ssl;
        server_name ckaquestion.k8s.local;
        ssl_certificate     /etc/nginx/tls/tls.crt;
        ssl_certificate_key /etc/nginx/tls/tls.key;
        ssl_protocols TLSv1.2 TLSv1.3;
        location / {
          return 200 "hello over TLS\n";
        }
      }
    }
EOF

echo "Creating Deployment 'nginx-static' (mounts config + tls)..."
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-static
  namespace: nginx-static
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-static
  template:
    metadata:
      labels:
        app: nginx-static
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 443
          protocol: TCP
        volumeMounts:
        - name: nginx-config
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        - name: nginx-tls
          mountPath: /etc/nginx/tls
          readOnly: true
      volumes:
      - name: nginx-config
        configMap:
          name: nginx-config
      - name: nginx-tls
        secret:
          secretName: nginx-tls
EOF

echo "Creating Service 'nginx-static' (port 443)..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: nginx-static
  namespace: nginx-static
spec:
  selector:
    app: nginx-static
  ports:
  - name: https
    port: 443
    targetPort: 443
    protocol: TCP
EOF

echo ""
echo "=== Setup complete ==="
echo "  - Namespace: nginx-static"
echo "  - ConfigMap nginx-config currently allows TLSv1.2 AND TLSv1.3"
echo "  - Secret nginx-tls (CN=ckaquestion.k8s.local)"
echo "  - Deployment nginx-static + Service on 443"
echo ""
echo "See TASK.md for full instructions."
