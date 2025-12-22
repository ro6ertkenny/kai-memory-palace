# 🚦 Bootstrap Preflight & Invariants
*Conditions that must be true before kubeadm runs*

---

## 📌 Purpose

This document defines the **non-negotiable preflight conditions (“invariants”)**
required for a successful Kubernetes bootstrap using `kubeadm`.

These invariants must hold **before**:
- `kubeadm init`
- `kubeadm join`

If any invariant is violated, bootstrap failures become likely,
non-deterministic, or difficult to diagnose later.

This document exists to **prevent entire classes of bootstrap failures**.

---

## 🧠 Operator Mental Model

Think of bootstrap as a contract:

> *If these invariants are true, kubeadm behaves predictably.*  
> *If they are false, failures may surface much later and appear unrelated.*

Operators enforce invariants **before** touching Kubernetes tooling.

---

## 🔒 Core Invariants (Must Always Hold)

### 1️⃣ Operating System State

- Swap is **disabled**
- Required kernel modules are **loaded**
- Required sysctl parameters are **set and persistent**
- The OS is supported by the Kubernetes version in use

Violating OS invariants often causes:
- kubelet startup failures
- node NotReady states
- silent scheduling problems

---

### 2️⃣ Container Runtime Readiness

- Container runtime is installed and running
- Runtime matches kubelet expectations (CRI compatibility)
- Runtime configuration is stable and known

Common failure modes when violated:
- kubelet fails to register
- Pods fail to start
- misleading CRI errors during join

---

### 3️⃣ Networking Invariants

- Nodes can reach each other over the management network
- DNS resolution works reliably
- Hostnames are stable and unique
- No conflicting services occupy required ports

Networking issues during bootstrap often appear later as:
- CNI failures
- control-plane instability
- inter-node communication errors

---

### 4️⃣ Time Synchronization

- System clocks are synchronized (NTP or equivalent)
- Time drift is minimal across nodes

Time drift causes:
- certificate validation failures
- authentication errors
- subtle control-plane instability

This is one of the **most overlooked invariants**.

---

### 5️⃣ Identity and Persistence

- Hostnames will not change unexpectedly
- Node IPs are stable (or deliberately managed)
- Disk layout is understood and sufficient

Violations here lead to:
- kubelet identity conflicts
- etcd instability
- unrecoverable node states

---

## ⚠️ Invariants vs kubeadm Preflight Checks

`kubeadm` performs **preflight checks**, but:

- some invariants are outside kubeadm’s visibility
- some checks can be bypassed
- some failures surface only under load or during upgrades

Operators treat kubeadm checks as **necessary but not sufficient**.

---

## 🧭 Reference Context

These invariants are enforced and validated using the
**Raspberry Pi Kubernetes cluster** reference implementation.

That environment highlights:
- resource constraints
- networking sensitivity
- the cost of re-provisioning mistakes

However, the invariants documented here apply equally to:
- bare metal
- VMs
- cloud instances

---

## 📦 What Lives Next to This Document

This document pairs directly with:

- `bootstrap/kubeadm-workflow.md`  
  *How kubeadm is executed*

- `bootstrap/post-bootstrap-validation.md`  
  *How to confirm invariants still hold after bootstrap*

- `bootstrap/kubeadm-reset-and-recovery.md`  
  *What to do when invariants were violated*

Together, these form a **closed bootstrap lifecycle**.

---

## ▶️ Where to Start

Before running kubeadm on any node:

1. Verify OS invariants
2. Verify container runtime readiness
3. Verify networking and time sync
4. Confirm node identity assumptions

If an invariant cannot be guaranteed, **do not bootstrap**.

Bootstrap correctness is cheaper than recovery.

---
