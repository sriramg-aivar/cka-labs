# Solution – Scenario 16: NodePort Service

## Step 1 – Add a named container port to the Deployment

Patch the container to expose port 80 named `http`:

```bash
kubectl -n relative patch deployment nodeport-deployment --type=json -p='[
  {"op":"add","path":"/spec/template/spec/containers/0/ports","value":[
    {"name":"http","containerPort":80,"protocol":"TCP"}
  ]}
]'
```

(You can also `kubectl -n relative edit deploy nodeport-deployment` and add:)

```yaml
        ports:
        - name: http
          containerPort: 80
          protocol: TCP
```

## Step 2 – Create the NodePort Service

```bash
cat <<'EOF' > nodeport-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nodeport-service
  namespace: relative
spec:
  type: NodePort
  selector:
    app: nodeport-deployment
  ports:
  - name: http
    port: 80
    targetPort: 80
    protocol: TCP
    nodePort: 30080
EOF
kubectl apply -f nodeport-service.yaml
```

## Step 3 – Verify

```bash
kubectl -n relative get svc nodeport-service
kubectl -n relative get endpoints nodeport-service
kubectl -n relative rollout status deploy nodeport-deployment
```
