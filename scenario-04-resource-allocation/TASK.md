# Scenario 04 – Resource Requests & Limits

## Context

A `wordpress` Deployment runs in the `default` namespace with **3 replicas**. Each
pod has an `initContainer` named `init-setup` (image `busybox`) and a main container
running `wordpress:6.2-apache` on `containerPort: 80`. The pods currently have no
resource requests or limits, which risks node instability under load.

## Task

1. Scale the `wordpress` Deployment to **0** replicas.
2. Edit the Deployment to divide the node resources evenly across 3 pods — assign a
   fair, equal share of CPU and memory to each pod, keeping some overhead so the node
   stays stable.
3. **Both** the initContainer (`init-setup`) **and** the main container must use
   **exactly the SAME** resource requests and limits.
4. Scale the Deployment back to **3** replicas.

## Test AFTER fix

```bash
kubectl get deploy wordpress -n default -o jsonpath='{.spec.replicas}'   # 3
kubectl get deploy wordpress -n default \
  -o jsonpath='{.spec.template.spec.containers[0].resources}'
kubectl get deploy wordpress -n default \
  -o jsonpath='{.spec.template.spec.initContainers[0].resources}'
kubectl rollout status deploy wordpress -n default
```

## Hints

- Requests and limits must be present for both cpu and memory on both containers.
- The init and main container requests/limits must be identical to each other.
- Example fair values: requests `cpu: 300m` / `memory: 600Mi`, limits `cpu: 400m` / `memory: 700Mi`.

## Video

https://youtu.be/ZqGDdETii8c
