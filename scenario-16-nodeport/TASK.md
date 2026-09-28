# Scenario 16 – NodePort Service

## Context

The namespace `relative` contains a Deployment named `nodeport-deployment`
running `nginx` with 2 replicas (container name `nginx`). The container currently
does not declare a named port, and there is no Service exposing it.

## Task

1. Configure the Deployment's container to expose port `80`, named `http`,
   protocol `TCP`.
2. Create a Service named `nodeport-service` in namespace `relative` that:
   - Is of type `NodePort`.
   - Exposes container port `80` (protocol `TCP`).
   - Uses `nodePort` `30080`.
   - Selects the Deployment's pods (`app: nodeport-deployment`).

## Test AFTER fix

```bash
kubectl -n relative get deploy nodeport-deployment -o yaml | grep -A3 ports
kubectl -n relative get svc nodeport-service
kubectl -n relative get endpoints nodeport-service
```

## Hints

- `kubectl -n relative edit deploy nodeport-deployment` to add the named port
  under `containers[].ports`.
- The default label applied by `kubectl create deployment` is
  `app=nodeport-deployment`; use that as the Service selector.

Video walkthrough: see the CKA-PREP playlist.
