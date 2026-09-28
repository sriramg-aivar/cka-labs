# Solution – Scenario 06: Extract CRD Documentation

## Step 1 – List the cert-manager CRDs

```bash
kubectl get crd | grep cert-manager | tee /root/resources.yaml
```

This filters the full CRD list down to the cert-manager resources and writes
them to `/root/resources.yaml`.

## Step 2 – Extract the Certificate spec.subject documentation

```bash
kubectl explain certificate.spec.subject | tee /root/subject.yaml
```

`kubectl explain` prints the schema documentation for the requested field.
Any output format is accepted, so you may also use:

```bash
kubectl explain certificate.spec.subject --recursive | tee /root/subject.yaml
```

## Step 3 – Verify

```bash
cat /root/resources.yaml
cat /root/subject.yaml
```
