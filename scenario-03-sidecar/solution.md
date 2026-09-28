# Solution – Scenario 03: Add a Sidecar Container to WordPress

## Approach

Edit the Deployment to add a shared `emptyDir` volume named `log`, mount it at
`/var/log` on the existing `wordpress` container, and add a `sidecar` container that
also mounts it at `/var/log` and tails the log file.

## Step 1 – Edit the deployment

```bash
kubectl edit deploy wordpress -n default
```

Add a `volumeMounts` entry to the wordpress container, add the sidecar container,
and add the shared volume:

```yaml
    spec:
      containers:
      - name: wordpress
        image: wordpress:php8.2-apache
        ports:
        - containerPort: 80
        volumeMounts:
        - name: log
          mountPath: /var/log
      - name: sidecar
        image: busybox:stable
        command: ["/bin/sh", "-c", "tail -f /var/log/wordpress.log"]
        volumeMounts:
        - name: log
          mountPath: /var/log
      volumes:
      - name: log
        emptyDir: {}
```

## Alternative – patch

```bash
kubectl patch deploy wordpress -n default --type='strategic' -p '
spec:
  template:
    spec:
      containers:
      - name: wordpress
        volumeMounts:
        - name: log
          mountPath: /var/log
      - name: sidecar
        image: busybox:stable
        command: ["/bin/sh", "-c", "tail -f /var/log/wordpress.log"]
        volumeMounts:
        - name: log
          mountPath: /var/log
      volumes:
      - name: log
        emptyDir: {}
'
```

## Step 2 – Verify

```bash
kubectl rollout status deploy wordpress -n default
kubectl logs deploy/wordpress -c sidecar -n default
```
