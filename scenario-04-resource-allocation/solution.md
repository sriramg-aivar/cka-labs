# Solution – Scenario 04: Resource Requests & Limits

## Idea

Give each pod a fair, equal slice of node capacity with headroom, and apply the
**same** requests/limits to both the initContainer and the main container.

Example values used below:
- requests: `cpu: 300m`, `memory: 600Mi`
- limits: `cpu: 400m`, `memory: 700Mi`

## Step 1 – Scale to 0

```bash
kubectl scale deploy wordpress -n default --replicas=0
```

## Step 2 – Edit the deployment

```bash
kubectl edit deploy wordpress -n default
```

Set identical resources on the init and main containers:

```yaml
      initContainers:
      - name: init-setup
        image: busybox
        command: ["/bin/sh", "-c", "echo Preparing... && sleep 5"]
        resources:
          requests:
            cpu: "300m"
            memory: "600Mi"
          limits:
            cpu: "400m"
            memory: "700Mi"
      containers:
      - name: wordpress
        image: wordpress:6.2-apache
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "300m"
            memory: "600Mi"
          limits:
            cpu: "400m"
            memory: "700Mi"
```

## Alternative – patch

```bash
kubectl patch deploy wordpress -n default --type='strategic' -p '
spec:
  template:
    spec:
      initContainers:
      - name: init-setup
        resources:
          requests: {cpu: "300m", memory: "600Mi"}
          limits: {cpu: "400m", memory: "700Mi"}
      containers:
      - name: wordpress
        resources:
          requests: {cpu: "300m", memory: "600Mi"}
          limits: {cpu: "400m", memory: "700Mi"}
'
```

## Step 3 – Scale back to 3

```bash
kubectl scale deploy wordpress -n default --replicas=3
```

## Step 4 – Verify

```bash
kubectl rollout status deploy wordpress -n default
kubectl get deploy wordpress -n default -o jsonpath='{.spec.replicas}'   # 3
```
