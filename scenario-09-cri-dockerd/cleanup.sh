#!/bin/bash

echo "=== Cleaning up Scenario 09 ==="
echo ""
echo "NOTE: This scenario modifies the node (installed package, started"
echo "service, changed sysctl parameters). This cleanup does not attempt a"
echo "destructive uninstall of cri-dockerd or revert node-wide sysctl changes."
echo ""
echo "To fully reset, restart the Killercoda scenario / recreate the playground."
echo ""

rm -f /root/cri-dockerd.deb

echo "=== Cleanup complete ==="
