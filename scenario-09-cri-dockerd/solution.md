# Solution – Scenario 09: Set up cri-dockerd

## Step 1 – Install the package

```bash
dpkg -i /root/cri-dockerd.deb
```

If dpkg reports missing dependencies, resolve them with `apt-get install -f`.

## Step 2 – Enable and start the service

```bash
systemctl enable --now cri-docker.service
systemctl is-active cri-docker.service
```

## Step 3 – Configure sysctl parameters persistently

```bash
cat <<'EOF' > /etc/sysctl.d/kube.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv6.conf.all.forwarding = 1
net.ipv4.ip_forward = 1
net.netfilter.nf_conntrack_max = 131072
EOF

sysctl --system
```

## Step 4 – Verify

```bash
systemctl is-active cri-docker.service
sysctl -n net.bridge.bridge-nf-call-iptables
sysctl -n net.ipv6.conf.all.forwarding
sysctl -n net.ipv4.ip_forward
sysctl -n net.netfilter.nf_conntrack_max
```
