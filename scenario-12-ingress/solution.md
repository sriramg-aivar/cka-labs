# Solution – Scenario 12: Expose Deployment via Ingress

## Step 1 – Create the NodePort Service

```bash
kubectl expose deployment echo -n echo-sound \
  --name echo-service \
  --type NodePort \
  --port 8080 --target-port 8080
kubectl get svc echo-service -n echo-sound
```

## Step 2 – Create the Ingress

```bash
cat <<'EOF' > echo-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo
  namespace: echo-sound
spec:
  rules:
  - host: example.org
    http:
      paths:
      - path: /echo
        pathType: Prefix
        backend:
          service:
            name: echo-service
            port:
              number: 8080
EOF
kubectl apply -f echo-ingress.yaml
```

## Step 3 – Verify

```bash
kubectl get svc echo-service -n echo-sound
kubectl get ingress echo -n echo-sound -o yaml
```
