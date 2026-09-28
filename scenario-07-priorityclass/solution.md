# Solution – Scenario 07: PriorityClass

## Step 1 – Find the highest existing user-defined priority value

```bash
kubectl get priorityclass
```

`user-critical` is the highest user-defined class at `1000`, so the new class must
be `999`.

## Step 2 – Create the high-priority PriorityClass

```bash
kubectl create priorityclass high-priority \
  --value=999 \
  --description="One less than user-critical"
```

## Step 3 – Patch the Deployment to use it

```bash
kubectl patch deployment busybox-logger -n priority \
  --type merge \
  -p '{"spec":{"template":{"spec":{"priorityClassName":"high-priority"}}}}'
```

## Step 4 – Verify

```bash
kubectl get priorityclass high-priority
kubectl get deploy busybox-logger -n priority \
  -o jsonpath='{.spec.template.spec.priorityClassName}'
kubectl rollout status deploy busybox-logger -n priority
```
