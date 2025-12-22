# 🔐 Certificates and Trust
*Control plane identity, authentication, and expiration management*

---

## 📌 Purpose

This document defines **certificate ownership and trust responsibilities**
for the Kubernetes control plane.

Certificates are not an implementation detail.
They define:

- who is allowed to talk to the API
- how components authenticate to each other
- whether the cluster can function at all

Most catastrophic Kubernetes failures ultimately trace back to
**broken trust or expired certificates**.

---

## 🧠 Operator Mental Model

Think of certificates as **time-bounded authority**.

If certificates:
- are valid → the cluster can operate
- expire → the cluster can appear “alive” but be functionally dead

Certificate management is **not optional maintenance**.
It is a core control-plane duty.

---

## 🧭 Trust Boundaries in Kubernetes

The control plane establishes trust between:

- API server ↔ clients (kubectl, controllers, schedulers)
- API server ↔ kubelets
- kubelets ↔ container runtime
- control-plane components ↔ etcd

Every interaction depends on:
- a trusted certificate authority
- valid, unexpired credentials
- consistent identity

Break any link and behavior becomes undefined.

---

## 🔑 Certificate Authority Ownership

In kubeadm-managed clusters:

- kubeadm creates and owns the cluster CA
- control-plane certificates are signed by this CA
- kubelet and component certs are issued and rotated under its authority

Operators must understand:
- where CA material lives
- which certs kubeadm manages automatically
- which certs require operator awareness

Losing CA material is a **cluster-ending event**.

---

## ⏳ Certificate Lifetimes and Expiration

Certificates have finite lifetimes.

Common realities:

- certificates expire silently
- expiration often surfaces as:
  - API authentication failures
  - kubelet disconnects
  - control-plane component crashes
- symptoms may look like networking or scheduling issues

Operators must track **expiration timelines**, not just current validity.

---

## 🔁 Certificate Rotation (Conceptual)

Certificate rotation involves:

- renewing expiring certificates
- maintaining trust continuity
- avoiding identity mismatch
- validating control-plane stability afterward

Rotation is safest when:
- performed intentionally
- validated immediately
- combined with control-plane health checks

Unplanned rotation during outages compounds failures.

---

## ⚠️ Common Failure Modes (Contextual)

> **⚠️ Mistake: Discovering expired certs during an outage**  
> Certificate expiration rarely causes clean failures.  
> It usually surfaces as cascading, confusing symptoms.

> **⚠️ Mistake: Treating cert rotation as “set and forget”**  
> kubeadm automates parts of rotation, not awareness.

> **⚠️ Mistake: Mixing identity changes with cert operations**  
> Changing hostnames or IPs during cert operations creates trust ambiguity.

---

## 🔍 Observability and Detection

Operators should be able to answer:

- when will control-plane certs expire?
- which components depend on which certs?
- what symptoms indicate trust failure?

Certificate issues should be **detected proactively**, not reactively.

---

## 🧭 Reference Context

Certificate practices documented here are grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters expose certificate failures clearly because:
- components are tightly coupled
- there is little redundancy
- recovery paths are narrow

The trust principles documented here remain portable
across environments.

---

## 🔗 Related Control Plane Docs

- `README.md`  
  Defines control-plane scope and lifecycle ownership

- `bootstrap/preflight-and-invariants.md`  
  Establishes trust assumptions before bootstrap

- `bootstrap/post-bootstrap-validation.md`  
  Verifies trust after bootstrap

- `upgrades/README.md`  
  Covers upgrade events that often intersect with cert rotation

Together, these documents define **trust as an operational lifecycle**, not a setup step.

---
