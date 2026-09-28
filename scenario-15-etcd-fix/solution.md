# Solution – Scenario 15: Fix kube-apiserver etcd Endpoint

## Step 1 – Inspect the broken manifest

```bash
sudo grep etcd-servers /etc/kubernetes/manifests/kube-apiserver.yaml
# --etcd-servers=https://127.0.0.1:2380   <-- wrong (peer port)
```

## Step 2 – Edit the manifest

```bash
sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml
```

Change the etcd endpoint from the peer port `2380` to the client port `2379`:

```yaml
    - --etcd-servers=https://127.0.0.1:2379
```

Alternatively, do it non-interactively:

```bash
sudo sed -i 's|--etcd-servers=https://127.0.0.1:2380|--etcd-servers=https://127.0.0.1:2379|' \
  /etc/kubernetes/manifests/kube-apiserver.yaml
```

## Step 3 – Wait for the static pod to restart and verify

```bash
# The kubelet re-creates the pod automatically when the manifest changes.
sleep 20
kubectl get nodes --request-timeout=10s
kubectl get pods -n kube-system -l component=kube-apiserver
```

The API server should become reachable and `kubectl get nodes` should succeed.
