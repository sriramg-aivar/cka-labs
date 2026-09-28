# Solution – Scenario 10: Taints & Tolerations

## Step 1 – Add the taint to node01

```bash
kubectl taint nodes node01 PERMISSION=granted:NoSchedule
kubectl describe node node01 | grep -i taint
```

## Step 2 – Create a Pod with the matching toleration

```bash
cat <<'EOF' > tolerating-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  nodeName: node01
  tolerations:
  - key: "PERMISSION"
    operator: "Equal"
    value: "granted"
    effect: "NoSchedule"
  containers:
  - name: nginx
    image: nginx:1.25
EOF
kubectl apply -f tolerating-pod.yaml
```

> `nodeName: node01` pins the pod to node01. You could also rely on the scheduler,
> but the toleration is what allows the pod to land on the tainted node.

## Step 3 – Verify

```bash
kubectl get pod nginx -o wide           # should be Running on node01
kubectl describe node node01 | grep -i taint
```
