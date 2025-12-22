# ⬆️ Control Plane Upgrades
*Sequencing, safety, and trust preservation*

---

## 📌 Purpose

This document defines **operator responsibilities for upgrading the Kubernetes
control plane**.

Control-plane upgrades are **high-risk, high-impact** operations because they
directly affect:
- API availability
- scheduler and controller behavior
- certificate and trust continuity
- etcd compatibility and performance

This document focuses on **how operators plan, execute, validate, and recover**
from control-plane upgrades—not on automation tooling.

---

## 🧠 Operator Mental Model

Think of a control-plane upgrade as a **surgical procedure**:

- prepare the patient (preconditions)
- operate in a precise sequence
- validate continuously
- stop and stabilize at the first anomaly

Upgrades succeed because of **discipline**, not speed.

---

## 🔁 Upgrade Preconditions (Non-Negotiable)

Before any control-plane upgrade:

- the control plane is healthy and stable
- etcd is healthy with recent, verified backups
- certificates are valid with sufficient remaining lifetime
- API server latency and error rates are normal
- no unrelated maintenance or experiments are in progress

If the cluster is not healthy **before** the upgrade,
the upgrade will amplify existing problems.

---

## 🔀 Upgrade Sequencing (Conceptual)

Control-plane upgrades follow a strict order:

1. Prepare and validate environment
2. Upgrade control-plane components
3. Validate control-plane health
4. Upgrade worker nodes (separately, later)

The control plane **defines behavior**.
Workers follow.

---

## 🧭 What “Upgrading the Control Plane” Means

A control-plane upgrade affects:

- kube-apiserver
- kube-scheduler
- kube-controller-manager
- kubeadm configuration
- certificates and trust metadata
- API compatibility guarantees

It does **not** automatically upgrade:
- worker kubelets
- CNI plugins
- CSI drivers

Operators must manage these boundaries explicitly.

---

## 🔐 Certificates and Upgrades

Upgrades frequently intersect with **certificate lifecycle events**.

Operators must account for:

- certificate expiration windows
- kubeadm-managed cert rotation
- trust continuity across versions
- API authentication behavior post-upgrade

Many “upgrade failures” are actually **latent certificate failures**.

---

## 🗄️ etcd Considerations

etcd is the **upgrade safety anchor**.

Before upgrading:
- confirm etcd health
- take and verify snapshots
- understand version compatibility

During upgrades:
- monitor etcd latency
- avoid write-heavy operations

After upgrades:
- confirm state consistency
- watch for delayed reconciliation or leader instability

Never upgrade the control plane without a **known-good etcd recovery path**.

---

## ❤️ Validation After Each Step

Validation is mandatory after **every control-plane change**.

Key signals include:
- API server responsiveness
- scheduler activity
- controller convergence
- absence of crash loops
- stable etcd leadership

If validation fails:
- stop immediately
- stabilize
- diagnose before proceeding

Upgrades fail most often because validation is skipped.

---

## ⚠️ Common Upgrade Failure Patterns

> **⚠️ Mistake: Upgrading control plane and workers together**  
> This removes rollback options and obscures root cause.

> **⚠️ Mistake: Treating kubeadm success as upgrade success**  
> kubeadm finishing does not mean the control plane is healthy.

> **⚠️ Mistake: Ignoring subtle API latency increases**  
> Small latency changes often precede major failures.

---

## 🧭 Reference Context

Control-plane upgrade practices here are grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters amplify upgrade risk because:
- redundancy is limited
- resource margins are thin
- rollback paths are narrow

The principles documented here remain portable
across environments.

---

## 🔗 Related Control Plane Docs

- `README.md`  
  Defines control-plane scope and ownership

- `certificates-and-trust.md`  
  Covers identity and expiration risks

- `etcd-health-and-recovery.md`  
  Defines state durability and recovery

- `api-server-availability-and-performance.md`  
  Covers performance regression detection

- `scheduler-and-controller-behavior.md`  
  Explains convergence expectations post-upgrade

Together, these documents define **control-plane upgrades as a lifecycle discipline**.

---
