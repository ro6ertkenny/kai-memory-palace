# ⬆️ Node Upgrades
*Rolling evolution, risk isolation, and capacity continuity*

---

## 📌 Purpose

This document defines **operator responsibility for upgrading worker nodes**
safely and predictably.

Worker-node upgrades are **routine but high-churn** operations. Done well,
they are invisible. Done poorly, they create cascading instability.

This document focuses on **sequencing, validation, and rollback discipline**
for worker-node upgrades.

---

## 🧠 Operator Mental Model

Think in terms of **rolling change with guardrails**.

- Change one node at a time
- Preserve cluster capacity
- Validate before proceeding
- Be ready to stop or roll back

Worker nodes are replaceable; **workloads are not**.

---

## 🔁 What Constitutes a Node Upgrade

Worker-node upgrades may include:

- Kubernetes version updates (kubelet)
- container runtime updates
- OS and kernel updates
- security patches
- configuration changes impacting execution

Upgrades must be **scoped to the node** and isolated from control-plane changes.

---

## 🔀 Safe Upgrade Sequence (Conceptual)

A safe worker-node upgrade follows this sequence:

1. **Assess readiness**
2. **Cordon the node**
3. **Drain workloads**
4. **Perform upgrade**
5. **Validate node health**
6. **Uncordon and observe**
7. **Proceed to next node**

Deviation increases risk.

---

## ❤️ Readiness Checks Before Upgrade

Before upgrading a node, confirm:

- cluster has sufficient spare capacity
- workloads tolerate disruption (PDBs understood)
- node is otherwise healthy
- no ongoing cluster incidents exist

Never upgrade during instability.

---

## 🔍 Validation After Upgrade

After maintenance and before uncordoning:

- kubelet is running and stable
- container runtime is healthy
- node conditions are normal
- scheduling works as expected
- no unexpected taints or labels exist

After uncordoning:
- monitor workload placement
- watch for resource pressure
- observe kubelet stability

---

## ⚠️ Common Upgrade Failure Patterns (Contextual)

> **⚠️ Mistake: Upgrading multiple nodes simultaneously**  
> This removes capacity and complicates diagnosis.

> **⚠️ Mistake: Skipping drain to “save time”**  
> This creates unplanned outages.

> **⚠️ Mistake: Treating post-upgrade success as immediate**  
> Some failures surface only under load.

---

## 🔁 Rollback and Replacement Strategy

Rollback options include:

- reverting configuration or package changes
- rebooting to previous kernel
- replacing the node entirely

Replacement is often cheaper and safer than repair.

Workers are **execution capacity**, not pets.

---

## 🧭 Reference Context

Worker-node upgrade practices here are grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters amplify upgrade impact because:
- capacity margins are thin
- errors surface immediately
- recovery paths are limited

The principles documented here remain portable
across environments.

---

## 🔗 Related Worker Node Docs

- `README.md`  
  Defines worker-node lifecycle and scope

- `draining-and-maintenance.md`  
  Covers safe workload movement

- `runtime-and-resource-management.md`  
  Explains pressure and eviction behavior

- `node-failure-and-recovery.md`  
  Covers response when upgrades go wrong

Together, these documents define **controlled, repeatable worker evolution**.

---
