# Scenario 08 – Install a CNI with NetworkPolicy Support

## Context

The cluster needs a Container Network Interface (CNI) plugin installed. You must
choose and install a CNI that meets **all** of these requirements:

- Pods can communicate with each other across nodes.
- The CNI **enforces** Kubernetes `NetworkPolicy` resources.
- It can be installed from a manifest.

You are offered two options:

- **Flannel v0.26.1** —
  `https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml`
- **Calico v3.28.2** —
  `https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml`

> ⚠️ This scenario modifies cluster-wide networking.

## Task

Install the CNI that satisfies the requirements. Flannel provides pod networking but
does **not** enforce `NetworkPolicy`, so the correct choice is **Calico**.

## Test AFTER fix

```bash
kubectl get pods -n tigera-operator
kubectl get pods -n calico-system
kubectl get nodes            # all nodes should be Ready
```

## Hints

- Only one of the two options enforces NetworkPolicy. Flannel does not.
- Install Calico via its operator manifest:
  `kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml`
- Wait for the calico components to become Running and nodes to be Ready.

## Video

https://youtu.be/Uc04Ui4x3EM
