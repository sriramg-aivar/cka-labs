# Scenario 06 – Extract CRD Documentation

## Context

The cert-manager CustomResourceDefinitions (CRDs) are installed in the cluster
(the `cert-manager` namespace exists). You need to inventory the cert-manager
CRDs and pull documentation for a specific field of the `Certificate` custom
resource using `kubectl`.

## Task

1. List all cert-manager CRDs and save the output to `/root/resources.yaml`.
2. Using `kubectl`, extract the documentation for the `subject` field of the
   `Certificate` custom resource `spec` and save it to `/root/subject.yaml`
   (any `kubectl` output format is acceptable).

## Test AFTER fix

```bash
cat /root/resources.yaml        # should list cert-manager CRDs
cat /root/subject.yaml          # should describe the Certificate spec.subject field
```

## Hints

- `kubectl get crd` lists every CRD; filter with `grep cert-manager`.
- `kubectl explain <resource>.<path>` prints field documentation, e.g.
  `kubectl explain certificate.spec.subject`.
- Use `tee` to both view and save the output.

## Video

https://youtu.be/SA1DzLQaDJs
