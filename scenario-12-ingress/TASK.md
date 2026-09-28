# Scenario 12 – Expose Deployment via Ingress

## Context

The namespace `echo-sound` contains a Deployment named `echo` running
`gcr.io/google_containers/echoserver:1.10` and listening on containerPort `8080`.

## Task

1. Expose the `echo` Deployment with a Service named `echo-service`:
   - type `NodePort`
   - port `8080` (target port `8080`)
2. Create an Ingress named `echo` in namespace `echo-sound`:
   - host `example.org`
   - path `/echo`
   - routing to service `echo-service` on port `8080`

## Test AFTER fix

```bash
kubectl get svc echo-service -n echo-sound
kubectl get ingress echo -n echo-sound -o yaml
```

## Hints

- The fastest way to make the Service:
  `kubectl expose deployment echo -n echo-sound --name echo-service --type NodePort --port 8080 --target-port 8080`
- `kubectl explain ingress.spec.rules.http.paths`
- Use `pathType: Prefix` (or `Exact`) for the `/echo` path.

## Video

https://youtu.be/sy9zABvDedQ
