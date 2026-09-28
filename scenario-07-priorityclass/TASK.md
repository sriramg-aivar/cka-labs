# Scenario 07 – PriorityClass

## Context

The `priority` namespace contains a Deployment named `busybox-logger`. The cluster
already has a **user-defined** `PriorityClass` named `user-critical` with a value of
`1000`.

## Task

1. Create a new `PriorityClass` named `high-priority` whose value is exactly **one
   less** than the highest existing user-defined priority class. Since the highest
   user-defined value is `1000`, `high-priority` must be `999`.
2. Patch the Deployment `busybox-logger` in the `priority` namespace so its Pods use
   the `high-priority` PriorityClass.

## Test AFTER fix

```bash
kubectl get priorityclass high-priority
kubectl get deploy busybox-logger -n priority \
  -o jsonpath='{.spec.template.spec.priorityClassName}'
kubectl rollout status deploy busybox-logger -n priority
```

## Hints

- Find the highest existing user-defined priority value with
  `kubectl get priorityclass`.
- Create the class: `kubectl create priorityclass high-priority --value=999`.
- Patch the Deployment's pod template `spec.priorityClassName` (e.g. with
  `kubectl patch` or `kubectl edit`), then wait for the rollout.

## Video

https://youtu.be/CZzxGyF6OHc
