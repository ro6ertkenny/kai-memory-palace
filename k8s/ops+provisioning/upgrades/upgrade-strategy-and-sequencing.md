# 🧭 Upgrade Strategy & Sequencing
*Planning change, limiting blast radius, and preserving recovery paths*

---

## 📌 Purpose

This document defines **how operators design and sequence cluster-wide
Kubernetes upgrades**.

Upgrades are not defined by commands; they are defined by **decisions**.
A sound strategy minimizes:
- blast radius
- time-to-detect regressions
- irrecoverable states

This document exists to ensure upgrades are **intentional, staged, and reversible**.

---

## 🧠 Operator Mental Model

Think of upgrades as **controlled experiments**.

- introduce one change
- observe system response
- validate convergence
- decide whether to proceed

Speed is never the objective.
**Recoverability is.**

---

## 🔁 Strategic Principles

Effective upgrade strategies share these properties:

- **Small steps over large jumps**  
  Each step should be independently understandable and reversible.

- **Explicit hold points**  
  Progression requires a conscious decision, not momentum.

- **Single axis of change**  
  Change one dimension at a time (Kubernetes, OS, runtime, add-ons).

- **Recovery-first planning**  
  Know how to stop and roll back *before* starting.

---

## 🧭 Sequencing Hierarchy (Non-Negotiable)

Cluster-wide upgrades follow a strict hierarchy:

1. **Control Plane**
2. **Worker Nodes**
3. **Cluster Add-ons**

This order preserves authority, execution capacity, and observability.

Reversing this order creates ambiguity and limits recovery options.

---

## 🔀 Phase 0: Preparation

Before touching versions:

- confirm cluster health and stability
- verify etcd backups and restore paths
- check certificate expiration timelines
- review version skew compatibility
- ensure sufficient spare capacity

Preparation failures predict upgrade failures.

---

## 🔀 Phase 1: Control Plane Upgrade

Upgrade the control plane first to:
- establish new API behavior
- surface compatibility issues early
- preserve rollback options

After control-plane changes:
- validate API availability
- confirm controller and scheduler convergence
- monitor etcd health and latency

Do not proceed until stability is confirmed.

---

## 🔀 Phase 2: Worker Node Upgrades

Upgrade worker nodes incrementally to:
- preserve capacity
- limit disruption
- isolate failures

Key rules:
- one node at a time
- validate before proceeding
- stop at the first anomaly

Execution capacity follows authority.

---

## 🔀 Phase 3: Add-ons and Integrations

Upgrade add-ons last, including:
- CNI plugins
- CSI drivers
- ingress controllers
- observability stacks

Add-ons often have **tight version coupling**.
Upgrading them too early obscures root cause.

---

## ❤️ Validation and Hold Points

After each phase:
- validate cluster health
- observe for delayed symptoms
- decide explicitly whether to proceed

Hold points are not bureaucracy.
They are **risk controls**.

---

## ⚠️ Common Sequencing Failures (Contextual)

> **⚠️ Mistake: Combining control-plane and worker upgrades**  
> This removes isolation and complicates rollback.

> **⚠️ Mistake: Skipping preparation because “it worked last time”**  
> Upgrades fail due to accumulated drift.

> **⚠️ Mistake: Continuing despite ambiguous symptoms**  
> Ambiguity is a signal to stop, not push forward.

---

## 🧭 Reference Context

Upgrade sequencing documented here is grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters amplify sequencing errors because:
- redundancy is limited
- recovery margins are thin
- delayed failures surface quickly

The principles documented here remain portable
across environments.

---

## 🔗 Related Upgrade Docs

- `README.md`  
  Defines cluster-wide upgrade scope and ownership

- `control-plane/control-plane-upgrades.md`  
  Covers control-plane-specific mechanics

- `worker-nodes/node-upgrades.md`  
  Covers rolling worker-node upgrades

- `validation-and-hold-points.md`  
  Defines explicit go / no-go checks

Together, these documents define **upgrade safety through discipline**.

---

