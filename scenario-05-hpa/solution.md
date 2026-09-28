# Solution – Scenario 05: HorizontalPodAutoscaler

## Approach

Create an `autoscaling/v2` HPA. The `averageUtilization` and `behavior` fields are
only available in v2, so `kubectl autoscale` (which emits v1) is not enough for the
stabilization window — write the manifest directly.

## Apply the HPA manifest

```bash
kubectl apply -f - <<EOF
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: apache-server
  namespace: autoscale
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: apache-deployment
  minReplicas: 1
  maxReplicas: 4
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 30
EOF
```

## Verify

```bash
kubectl get hpa apache-server -n autoscale
kubectl get hpa apache-server -n autoscale -o yaml | grep -A5 behavior
```

Expected: `minReplicas: 1`, `maxReplicas: 4`, target CPU `50`, and
`scaleDown.stabilizationWindowSeconds: 30`.
