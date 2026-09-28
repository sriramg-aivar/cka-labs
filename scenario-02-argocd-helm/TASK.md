# Scenario 02 – Install Argo CD via Helm without CRDs

## Context

You need to install Argo CD into the cluster using Helm. The cluster administrator
has **already pre-installed the Argo CD CRDs** cluster-wide, so your rendered
manifest must **not** include any `CustomResourceDefinition` objects (installing
them again would cause conflicts).

`helm` must be installed in your environment. You will render (not directly install)
the manifest and save it to a file for review.

## Task

1. Add a Helm repository named `argocd` pointing to `https://argoproj.github.io/argo-helm`.
2. Create a namespace named `argocd`.
3. Render a Helm template from the `argo-cd` chart, version `7.7.3`, targeting the
   `argocd` namespace.
4. Ensure CRDs are **NOT** installed via the chart configuration.
5. Save the generated YAML manifest to `/root/argo-helm.yaml`.

## Test AFTER fix

```bash
test -s /root/argo-helm.yaml && echo "manifest exists and non-empty"
grep -c "kind: CustomResourceDefinition" /root/argo-helm.yaml   # should be 0
kubectl get ns argocd
```

## Hints

- `helm repo add <name> <url>` then `helm repo update`
- Disable CRDs with `--set crds.install=false`
- `helm template <release> <chart> --version <ver> --namespace <ns> > file.yaml`

## Video

https://youtu.be/e0YGRSjb8CU
