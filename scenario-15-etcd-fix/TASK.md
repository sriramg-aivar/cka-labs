# Scenario 15 – Fix kube-apiserver etcd Endpoint

## Context

After a cluster migration, the control-plane `kube-apiserver` will not come up.
Someone pointed the API server at the etcd **PEER** port `2380` instead of the
etcd **client** port `2379`. As a result the static pod keeps crashing and
`kubectl` calls fail.

> Run this scenario on a kubeadm control-plane node (e.g. the Killercoda
> `controlplane` node).

## Task

Fix the `kube-apiserver` static pod manifest so the API server connects to etcd
on port `2379` and the control plane comes back up.

## Test AFTER fix

```bash
sudo grep etcd-servers /etc/kubernetes/manifests/kube-apiserver.yaml
kubectl get nodes --request-timeout=10s
```

## Hints

- Static pod manifests live in `/etc/kubernetes/manifests/`.
- Edit `--etcd-servers` so it reads `https://127.0.0.1:2379`.
- The kubelet auto-restarts the static pod when the manifest changes; give it a
  few seconds before re-testing.

## ⚠️ When you're done

This scenario edits the control-plane static pod manifest. If the API server does
not recover (or you want a clean slate), **restart the Killercoda playground** to
get a fresh cluster before doing other labs.

Video walkthrough: https://youtu.be/IL448T6r8H4
