# Solution – Scenario 14: Default StorageClass

## Step 1 – Create the StorageClass (not default yet)

```bash
cat <<'EOF' > local-storage-sc.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
  annotations:
    storageclass.kubernetes.io/is-default-class: "false"
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
EOF
kubectl apply -f local-storage-sc.yaml
kubectl get sc
```

## Step 2 – Make local-storage the default

```bash
kubectl patch sc local-storage \
  -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

## Step 3 – Unset the default on local-path

```bash
kubectl patch sc local-path \
  -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```

## Step 4 – Verify only one default exists

```bash
kubectl get sc
# Only 'local-storage' should be marked (default).
kubectl get sc -o jsonpath='{range .items[*]}{.metadata.name}{"="}{.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}{"\n"}{end}'
```
