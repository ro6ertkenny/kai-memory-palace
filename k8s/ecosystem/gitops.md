# 🔁 GitOps
*Declarative workflows aligned with Kubernetes reconciliation*

---

## 📌 Purpose

This document explains **what GitOps is**, why it fits Kubernetes so well,
and the trade-offs operators must understand before adopting it.

GitOps is not a product.
It is a **workflow philosophy** built on Kubernetes’ declarative nature.

---

## 🧠 Core Mental Model

GitOps treats **Git as the source of truth** for desired cluster state.

From Kubernetes’ perspective:

- desired state is declared
- controllers reconcile continuously
- drift is corrected automatically

GitOps extends this model by:
- storing desired state in version control
- automating reconciliation from Git to cluster

Git defines *what should be*.
Kubernetes enforces it.

---

## 🔁 Why GitOps Exists

GitOps exists to solve common operational problems:

- configuration drift
- undocumented manual changes
- unclear deployment history
- difficult rollback
- environment inconsistency

By anchoring state in Git, GitOps:
- creates auditability
- enables repeatability
- supports safe rollback
- improves team collaboration

---

## 🧱 What GitOps Is (and Is Not)

GitOps **is**:
- declarative
- pull-based
- reconciliation-driven
- auditable

GitOps **is not**:
- a CI pipeline
- imperative deployment scripting
- a replacement for Kubernetes
- a guarantee of correctness

GitOps does not eliminate mistakes.
It makes them visible and recoverable.

---

## 🔁 Pull-Based Reconciliation

A defining GitOps trait is **pull-based operation**:

- controllers run inside the cluster
- they watch Git repositories
- they reconcile cluster state continuously

This contrasts with:
- push-based CI/CD
- manual `kubectl apply`
- environment-specific scripting

Pull-based reconciliation aligns with Kubernetes’ security and trust model.

---

## ⚠️ Common GitOps Pitfalls

> **⚠️ Mistake: Treating GitOps as deployment automation**  
> GitOps enforces state; it does not validate intent.

> **⚠️ Mistake: Committing broken state to Git**  
> Kubernetes will faithfully reconcile bad desired state.

> **⚠️ Mistake: Overloading Git with runtime decisions**  
> Git should define intent, not transient behavior.

---

## 🧠 GitOps and Observability

GitOps depends on observability:

- to detect reconciliation failures
- to surface drift and conflicts
- to diagnose unintended consequences

Without observability, GitOps becomes silent failure.

---

## 🔁 GitOps vs Traditional CI/CD

Key distinction:

- **CI/CD**  
  Builds and pushes artifacts

- **GitOps**  
  Declares and reconciles desired state

They complement each other.
They are not interchangeable.

---

## 🧭 Reference Context

GitOps workflows are valuable even in small clusters,
such as the **Raspberry Pi Kubernetes cluster** reference implementation.

Small environments reveal:
- reconciliation clarity
- rollback simplicity
- drift detection immediately

If GitOps feels opaque here,
it will be dangerous at scale.

---

## 🔗 Related Ecosystem Docs

- `observability.md`  
  Required to understand reconciliation behavior

- `helm.md`  
  Commonly used to structure GitOps-managed manifests

- `operators-and-crds.md`  
  Extends reconciliation beyond static resources

- `security-and-policy.md`  
  Controls who may change desired state

GitOps works best when it **amplifies understanding**, not automation.

---
