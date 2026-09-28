# Scenario 10 – Taints & Tolerations

## Context

You have a standard 2-node Killercoda cluster (`controlplane` and `node01`). No
application resources are pre-created for this task — you will work directly with
`node01`.

## Task

1. Add a taint to `node01` so that normal pods can no longer be scheduled onto it:
   - key: `PERMISSION`
   - value: `granted`
   - effect: `NoSchedule`
2. Schedule a Pod onto `node01` by giving it a **matching toleration** so that it
   is allowed to run there despite the taint.

## Test AFTER fix

```bash
kubectl describe node node01 | grep -i taint         # PERMISSION=granted:NoSchedule
kubectl get pods -o wide                             # your pod should be Running on node01
```

## Hints

- A toleration must match key, value and effect (operator `Equal`) to bind.
- Use `kubectl explain pod.spec.tolerations` to see the fields.
- Without the toleration a pod will stay `Pending` if it targets `node01`.

## Video

https://youtu.be/oy6Mdqt1-jk
