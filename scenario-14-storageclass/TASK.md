# Scenario 14 – Default StorageClass

## Context

You are working on a default Killercoda cluster which already ships with a
`local-path` StorageClass that is typically marked as the cluster **default**.
You must add a new StorageClass and make it the single default without disturbing
any existing Deployments or PVCs.

## Task

1. Create a `StorageClass` named `local-storage` with:
   - Provisioner: `rancher.io/local-path`
   - `volumeBindingMode`: `WaitForFirstConsumer`
   - Do **NOT** mark it as default initially.
2. Patch `local-storage` so it becomes the default StorageClass.
3. Ensure `local-storage` is the **ONLY** default StorageClass (unset the default
   annotation on `local-path`).

Do not modify any existing Deployments or PVCs.

## Test AFTER fix

```bash
kubectl get sc
kubectl get sc local-storage -o yaml | grep -E 'provisioner|volumeBindingMode|is-default-class'
# exactly one StorageClass should show (default)
```

## Hints

- The default annotation is `storageclass.kubernetes.io/is-default-class: "true"`.
- Patch example:
  `kubectl patch sc local-storage -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'`
- `kubectl explain sc`

Video walkthrough: https://youtu.be/di7X7OHn2fc
