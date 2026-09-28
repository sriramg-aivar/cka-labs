#!/bin/bash

echo "=== Cleaning up Scenario 11 ==="

kubectl delete httproute web-route --ignore-not-found
kubectl delete gateway web-gateway --ignore-not-found
kubectl delete ingress web --ignore-not-found
kubectl delete service web-service --ignore-not-found
kubectl delete deployment web-deployment --ignore-not-found
kubectl delete secret web-tls --ignore-not-found

# Note: GatewayClass 'nginx-class' and the Gateway API CRDs are intentionally left in place.

echo "=== Cleanup complete ==="
