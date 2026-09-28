# Scenario 13 – Choose the Least-Permissive NetworkPolicy

## Context

Two workloads exist:

- **frontend** — Deployment `frontend` in namespace `frontend`
  (`curlimages/curl`, sleeping), namespace labeled `name=frontend`.
- **backend** — Deployment `backend` (nginx) in namespace `backend`, exposed by
  Service `backend-service` on port 80.

Three candidate `NetworkPolicy` manifests have been written to
`/root/network-policies/`:

- `network-policy-1.yaml` — allow all ingress
- `network-policy-2.yaml` — frontend namespace + a broad `ipBlock`
- `network-policy-3.yaml` — only the frontend namespace/pod on port 80

## Task

1. Read all three candidate policy files.
2. Decide which one allows `frontend → backend` traffic in the **least permissive**
   way (least blast radius while still permitting the required traffic).
3. Apply **that** policy (and only that one) to the cluster.

## Test AFTER fix

```bash
kubectl get networkpolicy -n backend
kubectl get networkpolicy -n backend -o yaml
```

## Hints

- "Least permissive" = grant only what is required. Wildcard rules (`ingress: [{}]`)
  and broad `ipBlock` CIDRs open far more than a single frontend app needs.
- A `namespaceSelector` and `podSelector` inside the **same** `from` entry are ANDed
  together — that is tighter than listing them as separate peers.
- `kubectl explain networkpolicy.spec.ingress.from`

## Video

https://youtu.be/rA8mXYTU0W8
