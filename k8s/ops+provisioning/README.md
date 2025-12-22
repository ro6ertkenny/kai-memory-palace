# 🛠️ Kubernetes Ops & Provisioning
## Cluster lifecycle: build → operate → maintain

Mental mode: Owning the lifecycle.

This wing focuses on the **operational reality of Kubernetes**:
bringing clusters into existence, keeping them healthy, and recovering them when they fail.

This is where theory meets failure.

---

## 🎯 Purpose

This wing documents **Kubernetes operator knowledge** required to:

- provision clusters correctly (Day-1)
- operate and maintain clusters over time (Day-2)
- manage the boundary between Linux and Kubernetes
- diagnose and recover from real-world failures

The focus is **cluster ownership**, not application deployment.

---

## 🔁 Lifecycle Focus

### 🚀 Day-1 Operations (Provisioning)

- OS prerequisites and system preparation
- Container runtime / CRI setup (containerd)
- kubeadm workflows (`init`, `join`, `reset`)
- CNI selection and install timing
- Initial cluster validation and sanity checks

### 🔧 Day-2 Operations (Maintenance)

- Node lifecycle (cordon, drain, replace)
- Kubernetes and OS upgrades
- Certificate and token awareness
- Failure recovery and troubleshooting
- Operational decision-making over time

Application workloads are **explicitly out of scope**.

---

## 🧠 Learning Posture

- Assume things will fail
- Inspect before acting
- Prefer runbooks over memory
- Treat nodes as cattle, not pets
- Respect Linux ↔ Kubernetes boundaries

This wing is unapologetically operational.

---

## 🧭 Scope

This wing covers **cluster lifecycle and node-level operations**, including:

- Cluster bootstrapping
- Control plane and worker node responsibilities
- Container runtime boundaries
- Node joining, draining, and replacement
- Upgrade sequencing
- Backup and recovery concepts
- Cluster-level troubleshooting

This wing assumes **Kubernetes Foundations is complete**.

---

## 🗂️ Canonical Files

k8s/ops-provisioning/
- README.md
- bootstrap-overview.md
- kubeadm-workflow.md
- control-plane-nodes.md
- worker-nodes.md
- container-runtime.md
- cluster-upgrades.md
- troubleshooting.md
- backups-and-recovery.md
- mistakes.md

Each file represents a **real operational responsibility**.

---

## 📦 What Lives in This Wing

- Reusable runbooks and procedures
- Operational patterns and checklists
- Failure scenarios and recovery paths
- Cluster-level troubleshooting guides
- Lifecycle and architecture explanations

Content is intended to be **portable across environments**
(bare metal, virtualized, cloud-based).

---

## 🧭 Reference Implementations

Concepts in this wing are grounded using **concrete reference clusters**.

### Primary Reference

**Raspberry Pi Kubernetes Cluster (bare metal)**

rpi-cluster/
- pi-cluster-hardware.md
- pi-cluster-environment.md
- pi-cluster-snapshot.md

This cluster serves as:
- a practical teaching anchor
- a long-lived operational reference
- a worked example of the concepts documented here

Additional reference clusters may be added over time.

---

## 🔗 Relationship to Other Wings

- **Downstream of:** linux, k8s/foundations
- **Upstream of:** k8s/networking
- **Feeds into:** k8s/ecosystem

This wing teaches **how to operate Kubernetes**.
Other wings teach how to understand or extend it.

---

## 🧠 Core Outcome

After completing this wing, you should be able to say:

I can bring a Kubernetes cluster online,  
I can keep it healthy over time,  
and I can recover it methodically when it breaks.

That is operational ownership.
