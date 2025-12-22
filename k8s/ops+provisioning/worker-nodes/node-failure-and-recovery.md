# 🧯 Node Failure & Recovery
*Diagnosis, containment, and decisive remediation*

---

## 📌 Purpose

This document defines **operator responsibility for handling worker-node
failures** safely and decisively.

Worker nodes fail.
Disks fill, processes crash, kernels panic, networks flap.

The goal is not to prevent all failure, but to:
- detect failure early
- contain blast radius
- restore capacity quickly
- avoid compounding damage

Recovery is an **operational skill**, not a reaction.

---

## 🧠 Operator Mental Model

Think in terms of **containment first, repair second**.

- Protect workloads
- Preserve cluster stability
- Decide: *repair or replace*
- Move forward deliberately

Worker nodes are disposable.
Time spent “saving” a bad node is often wasted.

---

## 🔁 Failure Categories

Worker-node failures typically fall into one of these categories:

### ⚠️ Execution Failures
- kubelet crashes or hangs
- container runtime failures
- Pods failing to start or restarting repeatedly

### ⚠️ Resource Failures
- memory exhaustion
- disk or inode exhaustion
- PID pressure
- CPU starvation

### ⚠️ Connectivity Failures
- loss of API connectivity
- CNI/networking failures
- DNS issues

### ⚠️ Hardware / OS Failures
- disk corruption
- kernel panics
- repeated reboots
- power or thermal issues

Correct recovery depends on **accurate categorization**.

---

## ❤️ Detection and Early Signals

Operators should watch for:

- node transitioning to NotReady
- kubelet heartbeats stopping or flapping
- widespread Pod failures on a single node
- repeated container restarts
- persistent pressure conditions

Early intervention reduces recovery cost.

---

## 🔁 Recovery Decision Framework

When a node degrades, operators must decide:

### Option A: Repair
Choose repair when:
- failure cause is clear
- remediation is low risk
- node history is otherwise healthy

### Option B: Replace
Choose replacement when:
- failure is unclear or recurring
- node integrity is suspect
- recovery time exceeds rebuild time

Replacement is often the **correct default**.

---

## 🛠️ Safe Recovery Sequence (Conceptual)

A controlled recovery follows this pattern:

1. **Cordon the node**
2. **Drain workloads**
3. **Stabilize or remove the node**
4. **Validate cluster health**
5. **Repair or rebuild**
6. **Rejoin or replace**

Never attempt recovery while workloads are still scheduled.

---

## ⚠️ Common Recovery Mistakes (Contextual)

> **⚠️ Mistake: Debugging a failing node while it still runs workloads**  
> This risks data loss and cascading failures.

> **⚠️ Mistake: Rebooting repeatedly without diagnosis**  
> This hides root cause and delays resolution.

> **⚠️ Mistake: Treating replacement as failure**  
> Replacement is often the most professional response.

---

## 🔁 Post-Recovery Validation

After recovery or replacement, verify:

- node health and stability
- kubelet behavior under load
- scheduling correctness
- absence of pressure signals
- cluster convergence

Recovery is not complete until validation passes.

---

## 🧭 Reference Context

Failure and recovery practices here are grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters make failures obvious because:
- capacity is limited
- failures propagate quickly
- recovery margins are narrow

The principles documented here remain portable
across environments.

---

## 🔗 Related Worker Node Docs

- `README.md`  
  Defines worker-node lifecycle and scope

- `draining-and-maintenance.md`  
  Covers safe workload evacuation

- `node-upgrades.md`  
  Covers recovery when upgrades fail

- `runtime-and-resource-management.md`  
  Covers pressure and execution failures

Together, these documents define **resilient worker-node operations**.

---
