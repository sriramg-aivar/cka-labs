# Solution – Scenario 01: Recover MariaDB Using an Existing PersistentVolume

## Step 1 – Inspect the existing PV

```bash
kubectl get pv mariadb-pv -o yaml | grep -E 'storageClassName|storage:|accessModes' -A1
```

The PV uses `storageClassName: standard`, capacity `250Mi`, `ReadWriteOnce`.

## Step 2 – Create the PVC

```bash
cat <<'EOF' > pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb
  namespace: mariadb
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 250Mi
EOF
kubectl apply -f pvc.yaml
kubectl get pvc mariadb -n mariadb    # should become Bound
kubectl get pv mariadb-pv             # should show Bound
```

## Step 3 – Point the Deployment at the PVC

Edit `~/mariadb-deploy.yaml` and set the claim name:

```yaml
      volumes:
      - name: mariadb-storage
        persistentVolumeClaim:
          claimName: mariadb
```

## Step 4 – Apply and verify

```bash
kubectl apply -f ~/mariadb-deploy.yaml
kubectl rollout status deploy mariadb -n mariadb
kubectl get pods -n mariadb
```
