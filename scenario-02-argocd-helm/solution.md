# Solution – Scenario 02: Install Argo CD via Helm without CRDs

## Step 1 – Add the Helm repo and update

```bash
helm repo add argocd https://argoproj.github.io/argo-helm
helm repo update
```

## Step 2 – Create the namespace

```bash
kubectl create namespace argocd
```

## Step 3 – Render the template without CRDs and save it

```bash
helm template argocd argocd/argo-cd \
  --version 7.7.3 \
  --set crds.install=false \
  --namespace argocd \
  > /root/argo-helm.yaml
```

## Step 4 – Verify

```bash
# File exists and is not empty
test -s /root/argo-helm.yaml && echo OK

# No CRDs rendered
grep -c "kind: CustomResourceDefinition" /root/argo-helm.yaml   # expect 0

# Namespace present
kubectl get ns argocd
```

## One-liner

```bash
helm repo add argocd https://argoproj.github.io/argo-helm; helm repo update; helm template argocd argocd/argo-cd --version 7.7.3 --set crds.install=false --namespace argocd > /root/argo-helm.yaml
```
