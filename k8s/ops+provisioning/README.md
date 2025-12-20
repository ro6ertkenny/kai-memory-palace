# 🛠️ k8s / ops + provisioning
*Cluster lifecycle: build → operate → maintain*

---

## 📌 Purpose

This wing documents **Kubernetes operational knowledge** required to:

- provision clusters correctly (Day-1)
- operate and maintain clusters over time (Day-2)
- manage the boundary between Linux and Kubernetes
- diagnose and recover from real-world failures

The focus is **operator responsibility**, not application deployment.

---

## 🔁 Lifecycle Focus

### 🚀 Day-1 Operations (Provisioning)

- OS prerequisites and system configuration
- Container runtime / CRI setup (containerd)
- kubeadm workflows (`init`, `join`, `reset`)
- CNI selection and install timing
- Initial cluster validation

### 🔧 Day-2 Operations (Maintenance)

- Node lifecycle (cordon, drain, replace)
- Kubernetes and OS upgrades
- Certificate and token management
- Failure recovery and troubleshooting
- Operational decision-making over time

Application workloads are **out of scope**.

---

## 📦 What Lives in This Wing

- Reusable runbooks and procedures
- Operational patterns and checklists
- Failure scenarios and recovery paths
- Cluster-level troubleshooting guides
- Architecture and lifecycle explanations

Content here is intended to be **portable across environments**
(bare metal, virtualized, cloud-based).

---

## 🧭 Reference Implementations

Concepts in this wing are grounded using **concrete reference clusters**.

### Primary reference

**Raspberry Pi Kubernetes Cluster (bare-metal)**

Location:
rpi-cluster/  
├─ pi-cluster-hardware.md  
├─ pi-cluster-environment.md  
└─ pi-cluster-snapshot.md  

This cluster serves as:
- a practical teaching anchor
- a long-lived operational reference
- a worked example of the concepts documented here

Additional reference clusters may be added over time.

---

## 🧠 Related Wings

- **Kubernetes Foundations** → `../foundations/`  
  Pods, Services, Deployments, YAML mechanics

- **Kubernetes Networking** → `../networking/`  
  CNI behavior, kube-proxy, traffic flow

- **Linux** → `../../linux/`  
  OS prep, disks, networking, systemd

---

## ▶️ Where to Start

If you are new to this wing:

1. Review the lifecycle focus above
2. Explore the reference cluster documentation
3. Proceed into control-plane and worker-node runbooks

This wing assumes baseline familiarity with Kubernetes primitives.

---
