# 🔁 Kubernetes Upgrades
*Version lifecycle, risk management, and recovery*

---

## 📌 Purpose

This directory documents **Kubernetes upgrade operations** within the
`k8s/ops+provisioning` wing.

Upgrades are among the **highest-risk activities** an operator performs.
They directly affect:

- cluster availability
- API compatibility
- workload stability
- operator confidence and trust

This documentation focuses on **how operators plan, execute, validate,
and recover from upgrades**, not on automation tooling.

---

## 🔁 Lifecycle Focus

Upgrades are primarily a **Day-2 responsibility**, but they depend heavily
on correct Day-1 decisions.

---

### 🔧 Day-2 Upgrade Responsibilities

Operator responsibilities include:

- understanding supported version skew rules
- planning upgrade order and blast radius
- executing upgrades incrementally
- validating cluster health at each step
- detecting regressions early
- rolling back or recovering safely

An upgrade is not complete until **post-upgrade validation succeeds**.

---

## 🧠 Core Upgrade Principles

Effective Kubernetes upgrades follow a few core principles:

- **Incremental change beats large jumps**  
  Smaller version steps reduce unknowns.

- **Control plane first, workers second**  
  The API defines cluster behavior.

- **One variable at a time**  
  Avoid combining OS, runtime, and Kubernetes upgrades unless necessary.

- **Validation between steps is mandatory**  
  “It upgraded” is not the same as “it works”.

---

## 🔀 Version Skew Awareness

Operators must understand and respect:

- Kubernetes supported version skew
- kubelet ↔ control plane compatibility
- kubectl client version tolerance
- CNI and CSI compatibility constraints

Ignoring version skew rules is a common cause of subtle failures.

---

## 🔁 Upgrade Order (Conceptual)

A typical upgrade sequence follows this pattern:

1. Prepare and validate the environment
2. Upgrade the control plane
3. Validate API availability and core components
4. Upgrade worker nodes incrementally
5. Validate workloads and scheduling behavior
6. Monitor for delayed or cascading failures

This sequence minimizes blast radius and preserves recovery options.

---

## 🔐 Certificates and Upgrades

Upgrades frequently intersect with **certificate lifecycle events**.

Operators must account for:

- certificate expiration timelines
- kubeadm-managed certificate rotation
- trust continuity across upgrades
- failure symptoms caused by expired certs

Many “upgrade failures” are actually **certificate failures**.

---

## ⚠️ Common Upgrade Failure Modes

Upgrade-related failures often stem from:

- unsupported version combinations
- skipped intermediate versions
- kubelet incompatibility
- CNI or CSI incompatibility
- insufficient disk space
- latent configuration drift

Symptoms may appear **hours or days later**, not immediately.

---

## 🧭 Reference Context

Upgrade concepts in this directory are grounded using the
**Raspberry Pi Kubernetes cluster** as a reference implementation.

That cluster highlights:
- constrained resources
- slower upgrade cadence
- the importance of validation on small systems

The upgrade principles documented here remain portable
across environments.

---

## 📦 What Lives in This Directory

This directory will contain:

- upgrade planning checklists
- control-plane upgrade guidance
- worker-node upgrade workflows
- validation and rollback strategies
- real-world upgrade failure analyses

Exact commands and version details live in the
implementation repository; this directory documents
**operator reasoning and lifecycle discipline**.

---

## ▶️ Where to Start

If you are new to Kubernetes upgrades:

1. Understand version skew rules
2. Learn why control-plane upgrades come first
3. Practice incremental upgrades
4. Treat validation as non-optional

Upgrades are where Kubernetes operations
reward preparation and punish shortcuts.

---
