# Scenario 11 – Migrate Ingress to Gateway API

## Context

An existing `Ingress` named `web` (in the `default` namespace) serves the app
`web-service` over HTTPS at host `gateway.web.k8s.local`, terminating TLS with the
secret `web-tls`. A `GatewayClass` named `nginx-class` is already installed, and the
Gateway API CRDs are present.

Your team is migrating away from Ingress to the Gateway API.

## Task

1. Create a `Gateway` named `web-gateway` that preserves the existing TLS + listener
   configuration:
   - `gatewayClassName: nginx-class`
   - an HTTPS listener on port `443`
   - hostname `gateway.web.k8s.local`
   - TLS mode `Terminate`, `certificateRef` pointing at secret `web-tls`
2. Create an `HTTPRoute` named `web-route`:
   - hostname `gateway.web.k8s.local`
   - a routing rule: `PathPrefix /` → `web-service` port `80`

Use apiVersion `gateway.networking.k8s.io/v1`.

## Test AFTER fix

```bash
kubectl get gateway web-gateway -o jsonpath='{.spec.gatewayClassName}'; echo
kubectl get gateway web-gateway -o jsonpath='{.spec.listeners[0].hostname}'; echo
kubectl get httproute web-route -o yaml
```

## Hints

- `kubectl explain gateway.spec.listeners.tls`
- The Gateway listener carries the TLS + hostname; the HTTPRoute carries the path
  routing and backend reference.
- `certificateRefs` is a list under `listeners[].tls`.

## Video

https://youtu.be/G9zispvOCHE
