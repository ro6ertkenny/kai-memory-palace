# 🧰 Draining & Maintenance
*Safe workload movement and node intervention*

---

## 📌 Purpose

This document defines **operator responsibility for safely intervening on
worker nodes** through cordoning, draining, and maintenance activities.

Maintenance is inevitable.
The goal is to perform it **without violating workload guarantees** or
introducing avoidable instability.

Draining is not just a command — it is an **operational contract**.

---

## 🧠 Operator Mental Model

Think in terms of **intentional disruption**.

- Cordoning prevents *new* work
- Draining relocates *existing* work
- Maintenance changes *node state*
- Uncordoning restores *capacity*

Every step must preserve:
- workload correctness
- cluster convergence
- operator control

---

## 🔁 Maintenance Lifecycle (Conceptual)

Safe maintenance follows a predictable sequence:

1. **Assess impact**
2. **Cordon node**
3. **Drain workloads**
4. **Perform maintenance**
5. **Validate node health**
6. **Uncordon and observe**

Skipping steps increases risk and recovery cost.

---

## 🚫 Cordoning (Prevent New Scheduling)

Cordoning marks a node as unschedulable.

Key properties:
- existing Pods continue running
- no new Pods are placed
- scheduler behavior remains predictable

Cordoning is a **signal of intent** to both the cluster and operators.

---

## 🔄 Draining (Workload Eviction)

Draining safely removes Pods from a node by:

- respecting PodDisruptionBudgets
- evicting non-daemonset Pods
- preserving controller intent
- triggering rescheduling elsewhere

Operators must understand:
- which Pods can be evicted
- which Pods will block draining
- how PDBs affect progress

A blocked drain is a **design signal**, not an error.

---

## 🛠️ Maintenance Activities

Common maintenance tasks include:

- OS updates and reboots
- kubelet or runtime updates
- hardware replacement
- disk cleanup or expansion
- configuration changes

Maintenance must be **isolated to the node**.
Cluster-wide changes do not belong here.

---

## ❤️ Validation After Maintenance

Before uncordoning, verify:

- kubelet is healthy and stable
- container runtime is running
- node conditions are normal
- no unexpected taints exist
- workloads can start successfully

Uncordoning an unhealthy node spreads failure.

---

## ⚠️ Common Maintenance Mistakes (Contextual)

> **⚠️ Mistake: Draining without understanding PodDisruptionBudgets**  
> PDBs exist to prevent unsafe eviction.

> **⚠️ Mistake: Rebooting nodes without cordoning**  
> This causes unpredictable workload disruption.

> **⚠️ Mistake: Uncordoning immediately after maintenance**  
> Always validate first.

---

## 🔁 Emergency Draining

In urgent scenarios (hardware failure, security incidents):

- prioritize workload safety over speed
- expect disruption
- stabilize first, optimize later

Emergency drains should be **rare** and reviewed afterward.

---

## 🧭 Reference Context

Draining and maintenance practices here are grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters make disruption visible because:
- capacity is limited
- rescheduling options are fewer
- mistakes surface immediately

The principles documented here remain portable
across environments.

---

## 🔗 Related Worker Node Docs

- `README.md`  
  Defines worker-node lifecycle and scope

- `runtime-and-resource-management.md`  
  Explains pressure and eviction behavior

- `node-upgrades.md`  
  Covers rolling upgrade sequencing

- `node-failure-and-recovery.md`  
  Covers response to unplanned node loss

Together, these documents define **safe, intentional node intervention**.

---
