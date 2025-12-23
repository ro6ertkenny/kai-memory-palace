# ☸️ Kubernetes — Master Index
*A structured navigation map for understanding, operating, and extending Kubernetes*

---

## 📌 Purpose

This index provides a **single entry point** for all Kubernetes-related
knowledge in the **kai-memory-palace**.

It answers the question:

> “Where am I in my Kubernetes learning and operations journey,
and what should I read next?”

This index is **navigation and sequencing**, not instruction.

---

## 🧠 How This Repository Is Organized

Kubernetes knowledge is divided into **wings**, each with a distinct purpose
and mental mode.

The wings are intentionally ordered to:
- build correct mental models first
- introduce operations only after understanding
- extend the platform only after stability
- avoid abstraction overload

---

## 🧱 Wing Overview (Recommended Order)

### 1️⃣ `k8s/foundations/`
**Mental mode:** Understanding

This wing establishes:
- what Kubernetes is (and is not)
- core abstractions and responsibilities
- declarative reconciliation
- how to reason about system behavior

Start here if:
- Kubernetes feels “magical”
- commands feel memorized
- behavior feels unpredictable

This wing removes mystery.

---

### 2️⃣ `k8s/networking/`
**Mental mode:** Reasoning about connectivity

This wing establishes:
- Pod networking assumptions
- Services and virtual IPs
- DNS and service discovery
- Ingress, Egress, and NetworkPolicies

Start here if:
- networking feels confusing
- traffic flow is unclear
- failures feel non-obvious

This wing restores clarity.

---

### 3️⃣ `k8s/ops+provisioning/`
**Mental mode:** Operating the platform

This wing establishes:
- cluster lifecycle (Day-1 / Day-2)
- control plane responsibilities
- worker node operations
- upgrades, validation, and troubleshooting

Start here if:
- you are running a cluster
- you are responsible for uptime
- you want to operate Kubernetes safely

This wing builds discipline.

---

### 4️⃣ `k8s/ecosystem/`
**Mental mode:** Extending responsibly

This wing establishes:
- ecosystem boundaries
- Helm, operators, and CRDs
- observability and GitOps
- security and policy guardrails
- future-facing AI considerations

Start here if:
- the core platform is stable
- you are evaluating tools
- you want to extend Kubernetes safely

This wing enforces restraint.

---

## 🔁 How to Use This Index

- **New to Kubernetes**  
  → Start with `k8s/foundations/`

- **Running a cluster**  
  → Focus on `k8s/ops+provisioning/`

- **Debugging hard problems**  
  → Re-anchor in foundations or networking

- **Evaluating tools**  
  → Read `k8s/ecosystem/ecosystem-boundaries.md` first

Progression matters.
Skipping wings creates fragile understanding.

---

## 🔗 Cross-Wing Principles

All wings share these principles:

- Concept before command
- Declarative over imperative
- Boundaries before tools
- Visibility before automation
- Understanding before optimization

These principles protect platform integrity.

---

## 🎯 Core Outcome

After completing all Kubernetes wings, you should be able to say:

I understand how Kubernetes works,
I can operate it responsibly,
and I know when and how to extend it safely.

That is Kubernetes mastery.

---
