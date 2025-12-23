# 🤖 AI on Kubernetes
*Future-facing workloads, constraints, and platform pressure*

---

## 📌 Purpose

This document defines **why AI workloads deserve special treatment**
in Kubernetes and why they are intentionally isolated in the ecosystem wing.

AI on Kubernetes is not about tools.
It is about **pressure on the platform**.

This file exists to:
- capture emerging patterns without polluting core knowledge
- identify where Kubernetes abstractions are stressed
- prevent hype-driven architecture decisions

---

## 🧠 Core Mental Model

AI workloads are **resource-dominant**, not service-dominant.

Compared to traditional workloads, they:
- consume large, bursty resources
- stress scheduling and placement
- challenge networking assumptions
- amplify storage and I/O bottlenecks
- reduce margin for operator error

Kubernetes can run AI workloads —  
but **not without trade-offs**.

---

## 🔁 How AI Workloads Differ

AI workloads typically introduce:

- **accelerator dependence** (GPUs, TPUs)
- **long-running batch jobs**
- **checkpoint-heavy storage**
- **non-uniform scaling behavior**
- **tight coupling to hardware topology**

These characteristics collide with:
- generic scheduling assumptions
- fair-share resource models
- stateless service patterns

---

## 🧱 Pressure Points in Kubernetes

AI workloads commonly stress:

### 🧠 Scheduling
- device-aware placement
- fragmentation of scarce resources
- bin-packing inefficiencies

### 💾 Storage
- high-throughput reads
- large artifact persistence
- checkpoint durability

### 🌐 Networking
- east–west bandwidth saturation
- data locality sensitivity
- ingress patterns unlike web services

### 🔧 Operations
- slow failure recovery
- expensive restarts
- long feedback loops

These are **platform concerns**, not application bugs.

---

## ⚠️ Common AI-on-Kubernetes Mistakes

> **⚠️ Mistake: Treating AI workloads like microservices**  
> They are not request-driven systems.

> **⚠️ Mistake: Adopting GPU operators before understanding scheduling**  
> Operators amplify bad assumptions.

> **⚠️ Mistake: Overloading clusters with mixed workloads**  
> AI jobs and latency-sensitive services compete poorly.

> **⚠️ Mistake: Assuming Kubernetes abstracts hardware limits**  
> It does not — it exposes them.

---

## 🧠 Kubernetes’ Role (and Limits)

Kubernetes excels at:
- declaring intent
- managing lifecycle
- scheduling under constraints
- enforcing isolation

Kubernetes does **not**:
- optimize training efficiency
- manage model correctness
- abstract hardware reality
- eliminate capacity planning

AI success depends on **platform honesty**, not abstraction depth.

---

## 🔁 Why This File Is Isolated

AI on Kubernetes evolves rapidly.
Tooling changes faster than core principles.

This file is intentionally:
- conceptual
- non-prescriptive
- future-facing
- isolated from core wings

When patterns stabilize, they may earn promotion.
Until then, they remain quarantined.

---

## 🧭 Relationship to Other Wings

- Downstream of:
  - `k8s/foundations`
  - `k8s/networking`
  - `k8s/ops+provisioning`

- Strongly related to:
  - `k8s/ecosystem/observability.md`
  - `k8s/ecosystem/operators-and-crds.md`
  - `k8s/ecosystem/security-and-policy.md`

AI workloads magnify **every weakness** in a platform.

---

## Core Outcome

After reading this document, you should be able to say:

I understand why AI workloads stress Kubernetes,
I know where abstractions break down,
and I will approach AI adoption deliberately.

That restraint is platform maturity.

---
