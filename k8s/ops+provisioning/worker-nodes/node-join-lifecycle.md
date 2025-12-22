# 🔗 Node Join Lifecycle
*From prepared host to schedulable worker*

---

## 📌 Purpose

This document defines the **end-to-end lifecycle of a worker node joining
a Kubernetes cluster**.

A node join is not a single command; it is a **state transition**:

Prepared host → authenticated member → schedulable capacity

Understanding this lifecycle prevents:
- brittle joins
- long-term node instability
- silent execution failures

---

## 🧠 Operator Mental Model

Think of node join as **identity + trust + readiness**.

For a node to join successfully, it must:
- authenticate to the control plane
- establish durable identity
- report accurate health
- prove it can execute workloads

If any step is weak, the node may appear joined but **fail later under load**.

---

## 🔁 Join Phases (Conceptual)

The node join lifecycle progresses through distinct phases:

1. **Host Prepared**
2. **Join Initiated**
3. **Authentication & Registration**
4. **Readiness Established**
5. **Scheduling Enabled**

Operators should reason about failures by identifying **which phase failed**.

---

## 1️⃣ Host Prepared

Before joining, the node must satisfy baseline invariants:

- OS prerequisites validated
- container runtime installed and running
- kubelet installed and configured
- time synchronized
- network reachability confirmed
- hostname and identity stable

Failures here often surface later as kubelet instability.

---

## 2️⃣ Join Initiated

Join begins when the node attempts to authenticate with the control plane.

Key properties:
- uses a time-bounded join token
- relies on cluster CA trust
- establishes initial node identity

Expired tokens, mismatched trust, or clock drift commonly break this phase.

---

## 3️⃣ Authentication & Registration

During this phase:
- kubelet authenticates to the API server
- the node object is created
- certificates are issued or validated
- heartbeats begin

At this point, the node may appear in the cluster but is **not yet ready**.

---

## 4️⃣ Readiness Established

Readiness requires:
- stable kubelet heartbeats
- container runtime responsiveness
- networking initialized
- node conditions healthy

A node that registers but never becomes Ready is **not operational**.

Operators must distinguish:
- registration success
- readiness success

They are not the same.

---

## 5️⃣ Scheduling Enabled

A node becomes schedulable when:
- it is Ready
- no blocking taints are present
- resources are accurately reported

Only now does the node contribute **usable capacity**.

Scheduling failures at this stage often indicate:
- resource misreporting
- taints or labels
- kubelet/runtime issues

---

## ⚠️ Common Join Failure Patterns (Contextual)

> **⚠️ Mistake: Treating “node appears in kubectl” as success**  
> Visibility does not equal readiness or stability.

> **⚠️ Mistake: Joining multiple nodes before validating the first**  
> This multiplies noise and hides root causes.

> **⚠️ Mistake: Ignoring clock drift during joins**  
> Time issues often masquerade as auth or cert failures.

---

## 🔁 Re-Join and Replacement

Worker nodes are **replaceable** by design.

When a node is unstable:
- drain workloads
- remove the node cleanly
- rebuild or reprovision
- rejoin as a new identity

Attempting to “repair” a deeply unstable node often costs more
than replacement.

---

## 🧭 Reference Context

Node join behavior documented here is grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters amplify join issues because:
- resources are limited
- timing issues surface quickly
- retries are expensive

The principles documented here remain portable
across environments.

---

## 🔗 Related Worker Node Docs

- `README.md`  
  Defines worker-node lifecycle and scope

- `kubelet-and-node-agent.md`  
  Covers kubelet behavior during and after join

- `runtime-and-resource-management.md`  
  Covers execution readiness after join

- `troubleshooting/README.md`  
  Covers diagnosis when joins fail

Together, these documents define **safe, repeatable worker node onboarding**.

---
