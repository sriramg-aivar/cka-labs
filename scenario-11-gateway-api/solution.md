# Solution – Scenario 11: Migrate Ingress to Gateway API

## Step 1 – Inspect the existing Ingress

```bash
kubectl get ingress web -o yaml
kubectl get gatewayclass nginx-class
```

Note the host `gateway.web.k8s.local`, TLS secret `web-tls`, and backend
`web-service:80`.

## Step 2 – Create the Gateway

```bash
cat <<'EOF' > web-gateway.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: web-gateway
spec:
  gatewayClassName: nginx-class
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    hostname: gateway.web.k8s.local
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: web-tls
    allowedRoutes:
      namespaces:
        from: Same
EOF
kubectl apply -f web-gateway.yaml
```

## Step 3 – Create the HTTPRoute

```bash
cat <<'EOF' > web-route.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: web-route
spec:
  parentRefs:
  - name: web-gateway
  hostnames:
  - gateway.web.k8s.local
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: web-service
      port: 80
EOF
kubectl apply -f web-route.yaml
```

## Step 4 – Verify

```bash
kubectl get gateway web-gateway -o jsonpath='{.spec.gatewayClassName}'; echo
kubectl get gateway web-gateway -o jsonpath='{.spec.listeners[0].hostname}'; echo
kubectl get httproute web-route -o yaml
```
