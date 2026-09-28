# Scenario 09 – Set up cri-dockerd

## Context

A Debian package for `cri-dockerd` has been downloaded to `/root/cri-dockerd.deb`.
You must install it, run the `cri-docker` service, and configure the required
kernel networking sysctl parameters.

> ⚠️ This scenario modifies the node (installs a package, starts a service, and
> changes sysctl settings).

## Task

1. Install the package with `dpkg`:
   `dpkg -i /root/cri-dockerd.deb`
2. Enable and start the `cri-docker` service so it is active and starts on boot.
3. Set the following sysctl parameters (and make them persistent):
   - `net.bridge.bridge-nf-call-iptables=1`
   - `net.ipv6.conf.all.forwarding=1`
   - `net.ipv4.ip_forward=1`
   - `net.netfilter.nf_conntrack_max=131072`

## Test AFTER fix

```bash
systemctl is-active cri-docker.service          # active
sysctl -n net.bridge.bridge-nf-call-iptables    # 1
sysctl -n net.ipv6.conf.all.forwarding          # 1
sysctl -n net.ipv4.ip_forward                   # 1
sysctl -n net.netfilter.nf_conntrack_max        # 131072
```

## Hints

- `dpkg -i /root/cri-dockerd.deb` installs the package.
- `systemctl enable --now cri-docker.service` starts it and enables it at boot.
- Write the four params to a file under `/etc/sysctl.d/` (e.g. `kube.conf`) and run
  `sysctl --system` to apply persistently.

## Video

https://youtu.be/ybzo1vXiqjU
