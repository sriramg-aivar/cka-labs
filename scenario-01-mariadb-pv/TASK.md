# Scenario 01 – Recover MariaDB Using an Existing PersistentVolume

## Context

A user accidentally deleted the MariaDB Deployment (and its PVC) in the `mariadb`
namespace. The Deployment used persistent storage. A `PersistentVolume` named
`mariadb-pv` already exists and is **retained** for reuse — it is the only PV in the
cluster. A skeleton Deployment manifest is waiting for you at `~/mariadb-deploy.yaml`
with an empty `claimName`.

## Task

1. Create a `PersistentVolumeClaim` named `mariadb` in namespace `mariadb` with:
   - Access Mode: `ReadWriteOnce`
   - Storage request: `250Mi`
2. Edit `~/mariadb-deploy.yaml` so the volume uses the PVC you just created
   (set `claimName: mariadb`).
3. Apply the Deployment.
4. Ensure the PVC binds to the existing `mariadb-pv` and the Deployment becomes stable.

## Test AFTER fix

```bash
kubectl get pvc mariadb -n mariadb          # STATUS should be Bound
kubectl get pv mariadb-pv                    # should be Bound to mariadb/mariadb
kubectl rollout status deploy mariadb -n mariadb
```

## Hints

- The PV uses `storageClassName: standard`; a PVC without a `storageClassName` may
  not match. Check `kubectl get pv mariadb-pv -o yaml` to see what to match.
- `kubectl explain pvc.spec`
