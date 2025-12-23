# 🔀 Version Skew & Compatibility
*Understanding supported differences without breaking the cluster*

---

## 📌 Purpose

This document defines **operator responsibility for managing version skew and
compatibility** during Kubernetes upgrades.

Kubernetes is designed to tolerate **limited version differences** between
components—but only within well-defined boundaries.

Most subtle, delayed upgrade failures occur when these boundaries are violated.

---

## 🧠 Operator Mental Model

Think of version skew as **controlled tolerance**, not flexibility.

- Kubernetes supports *specific* skew ranges
- behavior outside those ranges is undefined
- undefined behavior rarely fails cleanly

Operators must upgrade with **compatibility awareness**, not optimism.

---

## 🔁 What “Version Skew” Means

Version skew refers to **intentional version differences** between:

- control plane components
- kubelets on worker nodes
- kubectl clients
- cluster add-ons (CNI, CSI, ingress, etc.)

Skew is allowed—but only in **one direction and within limits**.

---

## 🧭 Control Plane ↔ Kubelet Compatibility

Key principles operators must respect:

- control plane must be **equal to or newer than kubelets**
- kubelets may lag the control plane by a limited number of minor versions
- kubelets must never be newer than the control plane

Violating these rules often results in:
- nodes joining but failing under load
- unexplained kubelet errors
- silent scheduling or execution failures

---

## 🧭 kubectl Client Compatibility

kubectl clients are more tolerant but still bounded:

- kubectl may be newer or older than the control plane
- large version gaps increase risk of unexpected behavior
- CLI success does not guarantee API correctness

Operators should align kubectl reasonably close to the control-plane version,
especially during upgrades.

---

## 🔁 Add-ons and Integration Compatibility

Cluster add-ons frequently have **tighter coupling** than core components.

Common examples:
- CNI plugins
- CSI drivers
- ingress controllers
- observability stacks

These components may:
- rely on specific API versions
- break when deprecated APIs are removed
- require upgrades coordinated with control-plane changes

Add-ons must be treated as **first-class upgrade dependencies**.

---

## ⚠️ Common Skew-Related Failure Patterns (Contextual)

> **⚠️ Mistake: Allowing kubelets to run ahead of the control plane**  
> This creates undefined behavior and difficult-to-debug failures.

> **⚠️ Mistake: Ignoring add-on compatibility matrices**  
> Add-ons often fail *after* control-plane upgrades complete.

> **⚠️ Mistake: Assuming kubectl success means cluster health**  
> CLI operations may succeed even when controllers are broken.

---

## 🔁 Managing Skew During Rolling Upgrades

During rolling upgrades:

- control plane upgrades establish the new ceiling
- worker nodes upgrade incrementally within supported skew
- add-ons upgrade last, once APIs stabilize

Skew should be:
- temporary
- intentional
- tracked

Permanent skew increases operational risk.

---

## ❤️ Validation Under Skew

Operators must validate:
- scheduling behavior
- controller convergence
- workload execution
- absence of deprecated API usage

Some skew-related failures surface only under **real workload pressure**.

---

## 🧭 Reference Context

Version-skew behavior documented here is grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters make skew-related issues visible because:
- there is little redundancy
- behavior changes surface quickly
- recovery margins are narrow

The principles documented here remain portable
across environments.

---

## 🔗 Related Upgrade Docs

- `README.md`  
  Defines cluster-wide upgrade scope and ownership

- `upgrade-strategy-and-sequencing.md`  
  Defines when and in what order upgrades occur

- `control-plane/control-plane-upgrades.md`  
  Covers control-plane compatibility guarantees

- `worker-nodes/node-upgrades.md`  
  Covers rolling worker-node upgrades under skew

Together, these documents define **compatibility as an operational discipline**.

---
