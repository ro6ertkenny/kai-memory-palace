# 🔁 Cluster-Wide Kubernetes Upgrades
*Orchestrating change, managing risk, preserving trust*

---

## 📌 Purpose

This directory documents **cluster-wide Kubernetes upgrade strategy**
within the `k8s/ops+provisioning` wing.

Cluster-wide upgrades are among the **highest-risk activities** an operator performs.
They directly affect:

- cluster availability
- API compatibility
- workload stability
- operator confidence and trust

This directory focuses on **how operators coordinate upgrades across the entire
cluster**, not on individual component mechanics.

Component-specific details live elsewhere:
- control-plane upgrade mechanics → `control-plane/`
- worker-node upgrade mechanics → `worker-nodes/`

This directory owns **sequencing, coordination, validation, and recovery**.

---

## 🧭 Relationship to Other Directories

- `control-plane/`  
  Covers *how* the control plane is upgraded safely

- `worker-nodes/`  
  Covers *how* execution capacity is upgraded and maintained

This directory covers *when, why, and in what order* those upgrades occur.

Think of this directory as the **upgrade conductor**, not the instruments.

---

## 🔁 Lifecycle Focus

Cluster-wide upgrades are primarily a **Day-2 responsibility**, but they depend
heavily on correct Day-1 decisions.

Poor bootstrap or lifecycle discipline amplifies upgrade risk later.

---

### 🔧 Day-2 Cluster-Wide Responsibilities

Operator responsibilities include:

- understanding supported version skew rules
- planning upgrade order and blast radius
- coordinating control plane, worker, and add-on changes
- validating cluster health at explicit hold points
- detecting regressions early
- deciding when to stop, roll back, or recover

An upgrade is not complete until **post-upgrade validation succeeds**.

---

## 🧠 Core Upgrade Principles

Effective cluster-wide upgrades follow a few non-negotiable principles:

- **Incremental change beats large jumps**  
  Smaller version steps reduce unknowns and recovery cost.

- **Control plane defines behavior**  
  Control plane first, workers second, add-ons last.

- **One variable at a time**  
  Avoid mixing OS, runtime, Kubernetes, and add-on upgrades unless required.

- **Validation between phases is mandatory**  
  “It upgraded” is not the same as “the cluster is healthy”.

---

## 🔀 Version Skew and Compatibility Awareness

Operators must understand and respect:

- Kubernetes supported version skew
- kubelet ↔ control-plane compatibility
- kubectl client tolerance
- CNI, CSI, and add-on compatibility

Ignoring version skew rules is a **primary cause of subtle, delayed failures**.

---

## 🔁 Cluster-Wide Upgrade Flow (Conceptual)

A typical cluster-wide upgrade follows this pattern:

1. Prepare and validate the environment
2. Upgrade the control plane
3. Validate API availability and control-plane health
4. Upgrade worker nodes incrementally
5. Validate scheduling and workload behavior
6. Upgrade add-ons and cluster integrations
7. Monitor for delayed or cascading failures

Each phase must include an explicit **decision point** before proceeding.

---

## 🔐 Certificates and Upgrades

Cluster-wide upgrades frequently intersect with **certificate lifecycle events**.

Operators must account for:

- certificate expiration timelines
- kubeadm-managed certificate rotation
- trust continuity across version changes
- symptoms caused by expired or rotated certs

Many perceived “upgrade failures” are actually **latent certificate failures**.

---

## ⚠️ Common Cluster-Wide Failure Modes

Upgrade failures often stem from:

- unsupported version combinations
- skipped intermediate versions
- version skew violations
- CNI or CSI incompatibility
- insufficient disk or resource headroom
- latent configuration drift

Symptoms may appear **hours or days later**, not immediately.

---

## 🧭 Reference Context

Upgrade strategy documented here is grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

That cluster highlights:
- constrained resources
- narrow recovery margins
- the importance of explicit validation

The upgrade principles documented here remain portable
across environments.

---

## 📦 What Lives in This Directory

This directory will contain:

- cluster-wide upgrade strategy and sequencing
- version skew and compatibility guidance
- add-on and CNI upgrade coordination
- validation checkpoints and hold points
- rollback and recovery frameworks

Exact commands and version specifics live in the
implementation repository; this directory documents
**operator reasoning, coordination, and lifecycle discipline**.

---

## ▶️ Where to Start

If you are new to cluster-wide Kubernetes upgrades:

1. Understand version skew rules
2. Learn why control-plane upgrades come first
3. Treat validation as mandatory, not optional
4. Optimize for recovery, not speed

Cluster-wide upgrades reward preparation
and punish shortcuts.

---
