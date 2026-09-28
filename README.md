# 🎯 CKA Practice Labs

Practice **17 CKA exam-style scenarios** on a real **kubeadm cluster** (2 nodes: controlplane + node01).

Designed for **Killercoda** Kubernetes playgrounds — or any kubeadm cluster with 2 nodes.

> Based on the [CKA-PREP-2025](https://www.youtube.com) walkthroughs. Some scenarios
> (etcd, cri-dockerd, CNI) touch the control plane / nodes directly — use a throwaway
> playground, not a cluster you care about.

---

## Quick Start (Killercoda)

```bash
# 1. Open a Killercoda Kubernetes playground (2 nodes)
# 2. Clone this repo on the controlplane node:
git clone https://github.com/sriramg-aivar/cka-labs
cd cka-labs
cd cluster && ./create-cluster.sh && cd ..
./cka.sh
```

---

## How it works

```
╔═══════════════════════════════════════════════════════════════╗
║             CKA Practice Labs - Study Mode                    ║
╚═══════════════════════════════════════════════════════════════╝

  Progress: 0/17 completed

  ▶ Scenario 01/17: Recover MariaDB with Existing PV

  Options:
    [r] Run/Setup this scenario
    [t] Show Task (question)
    [s] Show Solution
    [c] Check my answer
    [x] Reset (cleanup) scenario
    [f] Full reset (cleans ALL scenarios)
    [d] Mark done & next →
    [n] Next scenario →
    [p] Previous scenario ←
    [l] List all scenarios
    [q] Quit
```

### Workflow

1. **`[r]`** — Setup scenario (creates resources, sets up the problem)
2. **Task shows on screen** — solve it in another terminal tab
3. **`[c]`** — Check your answer (automated validation)
4. **`[s]`** — View solution if stuck
5. **`[d]`** — Mark done, move to next

Progress is saved to `.cka-progress`. Quit with `[q]` (asks to save or reset progress).

You can also drive scenarios non-interactively:

```bash
./run.sh 05     # setup scenario 05 and print its task
./check.sh 05   # run the automated checks for scenario 05
./reset.sh 05   # clean up scenario 05
```

---

## All 17 Scenarios

| # | Topic | What you do |
|---|-------|-------------|
| 01 | Recover MariaDB with Existing PV | Recreate a PVC that binds a retained PV, repoint the Deployment |
| 02 | Install Argo CD via Helm | `helm template` the chart with CRDs disabled, save the manifest |
| 03 | Add Sidecar Container | Add a busybox log-tailing sidecar sharing a `/var/log` volume |
| 04 | Resource Requests & Limits | Set equal requests/limits across init + main containers |
| 05 | HorizontalPodAutoscaler | Create an HPA (50% CPU, 1–4 pods, 30s scaleDown window) |
| 06 | Extract CRD Documentation | List cert-manager CRDs and `kubectl explain` a spec field |
| 07 | PriorityClass | Create a PriorityClass and attach it to a Deployment |
| 08 | Install a CNI | Install a CNI that enforces NetworkPolicy (Calico) |
| 09 | Set up cri-dockerd | Install the deb, enable the service, set sysctl params |
| 10 | Taints & Tolerations | Taint node01 and schedule a Pod that tolerates it |
| 11 | Migrate to Gateway API | Convert an Ingress into a Gateway + HTTPRoute (TLS preserved) |
| 12 | Expose via Ingress | NodePort Service + Ingress host/path routing |
| 13 | Least-Permissive NetworkPolicy | Pick and apply the correct policy of three candidates |
| 14 | Default StorageClass | Create a StorageClass and make it the sole default |
| 15 | Fix kube-apiserver etcd | Repair the etcd endpoint (2380 → 2379) so the API server recovers |
| 16 | NodePort Service | Add a named container port and a NodePort Service on 30080 |
| 17 | Restrict nginx to TLSv1.3 | Edit a ConfigMap to drop TLSv1.2 and reload nginx |

---

## Cluster Info

| Node | Role | Access |
|------|------|--------|
| controlplane | Control plane | You're on it |
| node01 | Worker | `ssh node01` |

---

## Tips for the CKA Exam

- Practice each scenario until you can do it quickly and cleanly.
- kubernetes.io/docs is allowed — know where things are.
- `kubectl explain <resource>.<field>` is your best friend.
- Use `kubectl create` / `kubectl run` with `--dry-run=client -o yaml` for quick YAML.
- Know imperative commands: `kubectl expose`, `kubectl set image`, `kubectl scale`, `kubectl taint`.
- For control-plane scenarios (etcd), remember static pod manifests live in
  `/etc/kubernetes/manifests/` and the kubelet reloads them automatically.
- For debugging: `kubectl describe`, `kubectl logs`, `kubectl get events`, `crictl ps`.

---

## File Structure

```
cka-labs/
├── cka.sh                     # ← Interactive runner
├── run.sh                     # Run scenario by number
├── check.sh                   # Check scenario by number
├── reset.sh                   # Reset scenario by number
├── cluster/
│   ├── create-cluster.sh      # Verify cluster + CNI
│   └── destroy-cluster.sh     # Teardown info
├── scenario-01-mariadb-pv/
│   ├── TASK.md                # Exam-style question
│   ├── solution.md            # Full solution
│   ├── setup.sh               # Creates the problem
│   ├── cleanup.sh             # Resets everything
│   └── check.sh               # Validates your answer
├── ...
└── scenario-17-tls-config/
```

---

## Troubleshooting

### kubectl not working / connection refused

```bash
# Check if API server is running
crictl ps | grep kube-apiserver

# Restart kubelet
systemctl restart kubelet
sleep 30
kubectl get nodes
```

### Scenario won't set up (AlreadyExists errors)

Run reset first: press `[x]` in the menu, then `[r]` again.

### Pods stuck in Pending/ContainerCreating

```bash
kubectl describe pod <pod-name> -n <namespace>
# Check the Events section for the actual error
```

### NetworkPolicy scenarios not enforcing

You need a CNI that enforces NetworkPolicy (e.g. Calico). Flannel does **not**.
Scenario 08 walks through installing one.

### Using without Killercoda

Any kubeadm cluster with 2 nodes works best. Note:
- **kind / minikube** — most scenarios work, but node-level ones (09 cri-dockerd,
  15 etcd, 08 CNI) assume a kubeadm control-plane node.
- **Cloud VMs** — best experience (2 Ubuntu VMs with kubeadm).

---

Good luck with your CKA exam! ⭐
