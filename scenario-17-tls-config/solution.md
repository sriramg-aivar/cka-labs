# Solution – Scenario 17: Restrict nginx to TLSv1.3

## Step 1 – Edit the ConfigMap to keep only TLSv1.3

```bash
kubectl -n nginx-static edit configmap nginx-config
```

Change the `ssl_protocols` line so it lists only TLSv1.3:

```nginx
        ssl_protocols TLSv1.3;
```

(Non-interactive alternative — export, patch, re-apply, or use a here-doc to
replace the ConfigMap entirely.)

## Step 2 – Add the Service ClusterIP to /etc/hosts

```bash
CIP=$(kubectl -n nginx-static get svc nginx-static -o jsonpath='{.spec.clusterIP}')
echo "$CIP ckaquestion.k8s.local" | sudo tee -a /etc/hosts
```

## Step 3 – Restart the Deployment to pick up the new config

```bash
kubectl rollout restart deployment nginx-static -n nginx-static
kubectl -n nginx-static rollout status deploy nginx-static
```

## Step 4 – Verify

```bash
# TLSv1.2 must now be refused:
curl -vk --tls-max 1.2 https://ckaquestion.k8s.local   # expect handshake failure

# TLSv1.3 must succeed:
curl -vk --tlsv1.3 https://ckaquestion.k8s.local        # expect 200 / nginx page
```
