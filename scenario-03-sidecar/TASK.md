# Scenario 03 – Add a Sidecar Container to WordPress

## Context

A `wordpress` Deployment exists in the `default` namespace. It runs the
`wordpress:php8.2-apache` image and continuously appends application logs to
`/var/log/wordpress.log` inside the container. A team wants those logs streamed
to stdout by a dedicated logging sidecar.

## Task

1. Add a sidecar container named `sidecar` to the `wordpress` Deployment using image
   `busybox:stable`, running the command `/bin/sh -c "tail -f /var/log/wordpress.log"`.
2. Add a shared volume mounted at `/var/log` on **both** the `wordpress` container
   and the `sidecar` container, so the log file written by WordPress is visible to
   the sidecar.
3. Do not change the Deployment name or namespace.

## Test AFTER fix

```bash
kubectl get deploy wordpress -n default -o jsonpath='{.spec.template.spec.containers[*].name}'
kubectl rollout status deploy wordpress -n default
kubectl logs deploy/wordpress -c sidecar -n default    # should stream log lines
```

## Hints

- Use an `emptyDir` volume shared between both containers.
- Mount the same volume at `/var/log` in both containers.
- `kubectl explain deployment.spec.template.spec.containers.volumeMounts`

## Video

https://youtu.be/3xraEGGQJDY
