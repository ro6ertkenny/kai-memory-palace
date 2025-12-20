# Environment

This document describes the operating system, runtime, networking, and Kubernetes
environment used for the Raspberry Pi Kubernetes cluster.

The environment is intentionally designed to be **stable, reproducible, and
headless**, mirroring real-world server and cloud operating practices.

---

## Control Machine (kubectl)

Cluster administration is performed from a dedicated Linux desktop workstation.

- **Host:** ro6bx (Linux desktop)
- **Network Interface:** USB Wi-Fi adapter
- **IPv4 Address:** 192.168.1.86/24 (static)
- **Gateway:** 192.168.1.254
- **Configuration Method:** NetworkManager (`nmcli`)
- **Kubeconfig Location:** `~/.kube/config`

The kubeconfig file was copied from the control plane node:

- Source: `rpi-master:/etc/kubernetes/admin.conf`
- Destination: `~/.kube/config`

This separation allows cluster management without requiring direct login to
the control-plane node for routine operations.

---

## Cluster Nodes

All Raspberry Pi nodes use **wired Ethernet** and are configured with **static IPv4
addresses at the OS level** using Netplan.

| Node Name     | Role          | IPv4 Address     | OS                 | Kernel            | Container Runtime      | Kubernetes |
|--------------|---------------|------------------|--------------------|-------------------|------------------------|------------|
| rpi-master   | control-plane | 192.168.1.116/24 | Ubuntu 22.04.5 LTS | 5.15.0-1092-raspi | containerd://1.7.28    | v1.31.14   |
| rpi-worker1  | worker        | 192.168.1.117/24 | Ubuntu 22.04.5 LTS | 5.15.0-1092-raspi | containerd://1.7.28    | v1.31.14   |
| rpi-worker2  | worker        | 192.168.1.115/24 | Ubuntu 22.04.5 LTS | 5.15.0-1092-raspi | containerd://1.7.28    | v1.31.14   |
| rpi-worker3  | worker        | 192.168.1.118/24 | Ubuntu 22.04.5 LTS | 5.15.0-1092-raspi | containerd://1.7.28    | v1.31.14   |

---

## Networking

- **Topology:** Single local area network (LAN)
- **Gateway:** 192.168.1.254
- **DNS Servers:** 1.1.1.1, 8.8.8.8
- **IP Persistence:**
  - Netplan on Raspberry Pi nodes
  - NetworkManager on the control machine
- **SSH Access:** Supported via hostname and direct IP

Static addressing ensures that node identities remain stable across reboots
and configuration changes.

---

## Hostnames and Name Resolution

Each node’s hostname is explicitly set and preserved to maintain consistency
between Kubernetes node identity and SSH access.

- `/etc/hostname` is set per node:
  - rpi-master
  - rpi-worker1
  - rpi-worker2
  - rpi-worker3

- `/etc/hosts` entries are maintained on:
  - The control machine
  - Each cluster node

This ensures hostname-based SSH access remains stable and avoids confusion
when rebuilding, reimaging, or reconfiguring nodes.

---

## Kubernetes Configuration

- **Provisioning Method:** kubeadm
- **Cluster Version:** v1.31.14
- **Container Runtime:** containerd (systemd cgroups)
- **Control Plane Initialization:** Manual
- **Worker Node Join:** Manual

The cluster favors **transparency and understanding** over full automation,
allowing each layer of the system to be observed and reasoned about directly.

---

## Known Warnings

During network configuration, Netplan may emit warnings related to:

- `gateway4` deprecation
- Open vSwitch services not running

These warnings are expected in this environment and do not impact cluster
functionality or stability.

---

## Rationale

Static IP addressing and explicit hostname management are used to:

- Prevent Kubernetes node IP churn
- Preserve SSH stability and known_hosts entries
- Simplify troubleshooting and cluster operations
- Minimize dependency on ISP-managed router configuration

These choices prioritize long-term stability and operational clarity over
short-term convenience.
