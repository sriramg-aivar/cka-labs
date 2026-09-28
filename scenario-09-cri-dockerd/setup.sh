#!/bin/bash
set -e

echo "=== Setting up Scenario 09: Set up cri-dockerd ==="

DEB_URL="https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.20/cri-dockerd_0.3.20.3-0.debian-bullseye_amd64.deb"

echo "Downloading cri-dockerd package to /root/cri-dockerd.deb..."
wget -O /root/cri-dockerd.deb "$DEB_URL" || true

echo ""
echo "=== Setup complete ==="
echo "  - Package (attempted) download: /root/cri-dockerd.deb"
echo ""
echo "NOTE: This scenario modifies the node (installs a package, starts a"
echo "service, and changes sysctl parameters)."
echo ""
echo "TASK:"
echo "  1. dpkg -i /root/cri-dockerd.deb"
echo "  2. Enable + start cri-docker.service"
echo "  3. Set sysctl params:"
echo "       net.bridge.bridge-nf-call-iptables=1"
echo "       net.ipv6.conf.all.forwarding=1"
echo "       net.ipv4.ip_forward=1"
echo "       net.netfilter.nf_conntrack_max=131072"
echo ""
echo "See TASK.md for full instructions."
