# ♻️ kubeadm Reset & Recovery
*Safe teardown, cleanup, and controlled retry of bootstrap*

---

## 📌 Purpose

This document defines **safe reset and recovery practices** for Kubernetes
clusters bootstrapped with `kubeadm`.

It answers the operator question:

> *“When bootstrap went wrong—or needs to be redone—how do I reset without
creating new problems?”*

Reset is not failure; it is a **controlled operation**.

---

## 🧠 Operator Mental Model

Think of reset and recovery as **state hygiene**.

A correct reset must:
- remove Kubernetes state deterministically
- leave the OS and runtime predictable
- avoid hidden residue that poisons future attempts
- allow a clean, repeatable retry

Partial resets create **non-deterministic behavior** that is harder to debug
than the original failure.

---

## 🔁 When Reset Is Appropriate

A reset is appropriate when:

- bootstrap validation fails and root cause is unclear
- control plane components fail to stabilize
- certificates or identities are inconsistent
- networking was misconfigured early
- experimentation or learning requires a clean slate

Reset early rather than compounding mistakes.

---

## ⚠️ When Reset Is Dangerous

Proceed with caution when:

- etcd contains irreplaceable state
- workloads are running in production
- multiple control-plane nodes are involved
- external dependencies rely on cluster identity

In these cases, recovery may require **surgical repair**, not reset.

---

## 🔧 Reset Scope (Conceptual)

Reset occurs at multiple layers. Operators must understand **what is being reset**.

### 1️⃣ Kubernetes State
- kubeadm-managed manifests
- certificates and credentials
- kubeconfig files
- node registration state

### 2️⃣ Node-Level State
- kubelet state directories
- container runtime artifacts
- CNI configuration
- iptables and networking residue

### 3️⃣ OS-Level Assumptions
- swap state
- kernel modules
- sysctl settings
- time synchronization

A reset that ignores any layer is incomplete.

---

## 🔁 Control Plane Reset (Single-Node)

For a single-node control plane:

- stop kubelet
- run kubeadm reset
- remove residual directories
- reset networking artifacts if necessary
- re-verify preflight invariants

After reset, the node should resemble a **pre-bootstrap system**.

---

## 🔁 Worker Node Reset

For worker nodes:

- drain and remove the node if reachable
- stop kubelet
- run kubeadm reset
- clean runtime and CNI state
- rejoin only after control plane stability

Never rejoin a worker node to an unstable control plane.

---

## 🔍 Post-Reset Verification

After reset, verify:

- kubelet is stopped or cleanly restarted
- no Kubernetes manifests are running
- container runtime is healthy
- networking is restored to baseline
- time and identity invariants still hold

Only then should re-bootstrap begin.

---

## ⚠️ Common Reset Mistakes (Contextual)

> **⚠️ Mistake: Running kubeadm reset without cleaning CNI state**  
> Residual networking artifacts cause misleading failures on re-bootstrap.

> **⚠️ Mistake: Resetting workers before stabilizing control plane**  
> This multiplies noise without fixing the root issue.

> **⚠️ Mistake: Treating reset as a single command**  
> Reset is a process, not an incantation.

---

## 🧭 Reference Context

Reset and recovery practices here are informed by the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters make reset consequences obvious:
- limited resources
- fast feedback loops
- low tolerance for residue

These patterns remain valid across environments.

---

## 🔗 Related Bootstrap Docs

- `bootstrap-overview.md`  
  Defines the bootstrap lifecycle and responsibilities

- `preflight-and-invariants.md`  
  Defines what must be true before kubeadm runs

- `kubeadm-workflow.md`  
  Documents the kubeadm init/join flow

- `post-bootstrap-validation.md`  
  Defines how to prove bootstrap success

Together, these documents form a **closed bootstrap lifecycle**:
prepare → bootstrap → validate → reset/retry.

---
