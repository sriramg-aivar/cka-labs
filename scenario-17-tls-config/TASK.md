# Scenario 17 – Restrict nginx to TLSv1.3

## Context

The namespace `nginx-static` contains:

- A Deployment `nginx-static` serving HTTPS.
- A ConfigMap `nginx-config` holding `nginx.conf`, currently allowing **both**
  `TLSv1.2` and `TLSv1.3`.
- A TLS Secret `nginx-tls` (self-signed, CN `ckaquestion.k8s.local`).
- A Service `nginx-static` exposing the app on port `443`.

## Task

1. Edit the ConfigMap `nginx-config` so that **only** `TLSv1.3` is supported
   (remove `TLSv1.2` from `ssl_protocols`).
2. Add the Service ClusterIP to `/etc/hosts` mapped to
   `ckaquestion.k8s.local`.
3. Restart the Deployment so it picks up the new configuration.
4. Verify:
   - `curl -vk --tls-max 1.2 https://ckaquestion.k8s.local` **FAILS**.
   - `curl -vk --tlsv1.3 https://ckaquestion.k8s.local` **works**.

## Test AFTER fix

```bash
kubectl -n nginx-static get configmap nginx-config -o jsonpath='{.data.nginx\.conf}' | grep ssl_protocols
kubectl -n nginx-static rollout status deploy nginx-static
curl -vk --tls-max 1.2 https://ckaquestion.k8s.local   # should fail
curl -vk --tlsv1.3    https://ckaquestion.k8s.local    # should succeed
```

## Hints

- After editing a mounted ConfigMap, run
  `kubectl rollout restart deployment nginx-static -n nginx-static`.
- Get the ClusterIP with
  `kubectl -n nginx-static get svc nginx-static -o jsonpath='{.spec.clusterIP}'`.

Video walkthrough: see the CKA-PREP playlist.
