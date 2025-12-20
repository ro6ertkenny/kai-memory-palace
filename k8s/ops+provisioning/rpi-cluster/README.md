# 🧱 Raspberry Pi Kubernetes Cluster
*Reference implementation for ops + provisioning*

---

## 📌 Purpose of This Cluster

This directory documents a **Raspberry Pi–based Kubernetes cluster** used as a
**primary reference implementation** for the `k8s/ops+provisioning` wing of
`kai-memory-palace`.

The cluster exists to:

- ground Kubernetes operational concepts in real infrastructure
- provide a consistent example for Day-1 and Day-2 operations
- serve as a long-lived teaching and reference system
- anchor abstract concepts to concrete decisions and tradeoffs

This is a **reference cluster**, not a generic template.

---

## 🧭 How This Cluster Is Used

Within `kai-memory-palace`, this cluster is used to:

- illustrate provisioning and lifecycle concepts
- explain operational decision-making
- document real failure modes and recovery paths
- provide context for reusable runbooks

Concepts documented elsewhere in the wing may reference this cluster
without repeating its full build history.

---

## 📂 Cluster Documentation (Canonical)

Cluster-specific documentation lives here:

- **Hardware**  
  `pi-cluster-hardware.md`  
  Physical layout, power, cooling, networking, and build considerations

- **Environment**  
  `pi-cluster-environment.md`  
  OS, kernel, container runtime, Kubernetes versions, and system configuration

- **Snapshot**  
  `pi-cluster-snapshot.md`  
  Node inventory, roles, addressing, and current cluster state

These documents describe **what this cluster is**, not how to rebuild it step by step.

---

## 🔗 Implementation Repository

A complete, chronological, reproducible build of this cluster is documented in the
implementation repository:

**rpi-kubernetes-provisioning**

That repository contains:
- build narrative and rationale
- photos and scripts
- exact commands and sequencing
- a blueprint others can follow

This directory intentionally does **not** duplicate that material.

---

## 🔁 Relationship to ops + provisioning

This cluster is the **primary reference** for:

- kubeadm lifecycle discussions
- control-plane and worker-node operations
- upgrade and recovery scenarios
- Linux ↔ Kubernetes boundary decisions

Future clusters may be added as additional references, but this cluster
establishes the baseline.

---
