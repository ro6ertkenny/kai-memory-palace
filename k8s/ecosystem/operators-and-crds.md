# 🧠 Operators & CRDs
*Extending Kubernetes safely through reconciliation*

---

## 📌 Purpose

This document explains **how Kubernetes is designed to be extended**
using **CustomResourceDefinitions (CRDs)** and **operators**, and why
this model is fundamentally different from traditional automation.

Operators are powerful.
They are also easy to misuse.

This document exists to establish **correct mental models and guardrails**.

---

## 🧠 Core Mental Model

An operator is **software that understands a domain**
and continuously reconciles desired state for that domain.

From Kubernetes’ perspective:

- CRDs extend the API
- operators extend reconciliation logic
- Kubernetes remains the control plane

Operators do not “run scripts.”
They participate in the Kubernetes control loop.

---

## 🔁 What a CRD Is

A CustomResourceDefinition:

- adds a new API type to Kubernetes
- defines a schema and versioning
- allows users to declare desired state
- is stored and managed like native objects

CRDs are **first-class Kubernetes APIs**.

---

## 🔁 What an Operator Is

An operator:

- watches CRDs
- reconciles desired vs current state
- manages complex lifecycle actions
- encodes domain-specific knowledge

Operators turn **operational expertise into software**.

---

## 🧱 Why Operators Exist

Some systems are too complex for static manifests:

- databases
- message queues
- storage systems
- stateful platforms

Operators exist to:
- manage upgrades safely
- perform health-aware actions
- coordinate multi-step operations
- reduce human error

They formalize operations.

---

## ⚠️ Trade-offs and Risks

Operators introduce risk when they:

- act imperatively instead of reconciling
- hide failures behind abstractions
- require excessive privileges
- embed opaque control logic
- are poorly maintained

An operator is a **control-plane extension**.
Treat it with the same scrutiny.

---

## ❌ Common Misuse Patterns

> **⚠️ Mistake: Treating operators as installers**  
> Operators manage lifecycle, not one-time setup.

> **⚠️ Mistake: Assuming operators are safer than humans by default**  
> Bad operators amplify mistakes.

> **⚠️ Mistake: Installing many operators without understanding interactions**  
> Control loops can conflict.

---

## 🔁 Operators vs Helm

Helm and operators solve **different problems**:

- Helm packages manifests
- operators manage runtime behavior

Helm installs.
Operators reconcile.

Using Helm to install an operator is common.
Using Helm *instead of* an operator is not equivalent.

---

## 🧠 When to Use an Operator

Operators are appropriate when:

- lifecycle management is complex
- stateful systems are involved
- manual procedures are error-prone
- reconciliation provides safety

Avoid operators when:
- behavior is simple
- manifests are sufficient
- understanding would be lost

---

## 🧭 Reference Context

Operators are often deployed even in small clusters,
such as the **Raspberry Pi Kubernetes cluster** reference implementation.

Small environments highlight:
- control-plane impact
- failure behavior clearly
- reconciliation mistakes immediately

If an operator is unsafe here, it will be worse at scale.

---

## 🔗 Related Ecosystem Docs

- `ecosystem-boundaries.md`  
  Defines safe extension limits

- `helm.md`  
  Explains packaging vs lifecycle control

- `gitops.md`  
  Describes reconciliation-driven workflows

Operators extend Kubernetes **by becoming part of it**.

---
