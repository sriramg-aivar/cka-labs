# Scenario 05 – HorizontalPodAutoscaler

## Context

The `autoscale` namespace contains a Deployment named `apache-deployment` (image
`httpd`, with CPU `requests: 100m` and `limits: 200m`) exposed by a Service. The
metrics-server is installed so CPU metrics are available.

## Task

Create a `HorizontalPodAutoscaler` named `apache-server` in the `autoscale` namespace
that:

1. Targets the `apache-deployment` Deployment.
2. Maintains an average CPU utilization of **50%** per pod.
3. Scales between a minimum of **1** and a maximum of **4** replicas.
4. Uses a **downscale (scaleDown) stabilization window of 30 seconds**.

Use API version `autoscaling/v2`.

## Test AFTER fix

```bash
kubectl get hpa apache-server -n autoscale
kubectl get hpa apache-server -n autoscale -o yaml
```

## Hints

- `autoscaling/v2` supports both `metrics` and `behavior` fields.
- Set `spec.behavior.scaleDown.stabilizationWindowSeconds: 30`.
- Target CPU utilization goes under `spec.metrics[].resource.target.averageUtilization`.

## Video

https://youtu.be/YGkARVFKtmM
