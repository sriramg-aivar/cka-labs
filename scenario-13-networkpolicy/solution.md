# Solution – Scenario 13: Choose the Least-Permissive NetworkPolicy

## Step 1 – Read the three candidate policies

```bash
ls /root/network-policies/
cat /root/network-policies/network-policy-1.yaml
cat /root/network-policies/network-policy-2.yaml
cat /root/network-policies/network-policy-3.yaml
```

## Step 2 – Compare them

- **network-policy-1** — `ingress: [{}]` allows traffic from **everywhere**. Too open.
- **network-policy-2** — allows the `frontend` namespace **and** an entire
  `ipBlock 172.16.0.0/16`. The extra CIDR opens the backend to far more than the
  frontend pods. Too open.
- **network-policy-3** — allows only pods labeled `app=frontend` **inside** the
  namespace labeled `name=frontend`, on TCP port 80. This is the **least permissive**
  policy that still permits `frontend → backend`.

Note: the `namespaceSelector` + `podSelector` are combined in a **single `from`
entry** (a logical AND), which is what makes policy-3 tight.

## Step 3 – Apply the correct policy

```bash
kubectl apply -f /root/network-policies/network-policy-3.yaml
kubectl get networkpolicy -n backend
```

## Step 4 – (Optional) verify connectivity

```bash
FRONTEND_POD=$(kubectl get pod -n frontend -l app=frontend -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n frontend "$FRONTEND_POD" -- curl -s -m 5 backend-service.backend.svc.cluster.local
```
