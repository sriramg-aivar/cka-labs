# Solution – Scenario 08: Install a CNI with NetworkPolicy Support

## Step 1 – Choose the right CNI

The requirements demand a CNI that **enforces NetworkPolicy**. Flannel provides pod
networking but does not enforce NetworkPolicy on its own. **Calico** enforces
NetworkPolicy, so it is the correct choice.

## Step 2 – Install Calico from the manifest

```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml
```

## Step 3 – Wait for it to come up

```bash
kubectl get pods -n tigera-operator
kubectl get pods -n calico-system
kubectl get nodes
```

Wait until the tigera-operator and calico-system Pods are `Running` and all nodes
report `Ready`.

## Why not Flannel?

Flannel (`kube-flannel.yml`) sets up an overlay network for pod-to-pod
communication, but it does **not** implement the NetworkPolicy API. Applying a
`NetworkPolicy` under Flannel has no enforcing effect, which fails the requirement.
