# 🔍 DNS & Service Discovery
*How Kubernetes objects become reachable by name*

---

## 📌 Purpose

This document explains **how Kubernetes enables service discovery**
using DNS, and what guarantees (and non-guarantees) operators should expect.

Applications should not need to know:
- Pod IPs
- node addresses
- cluster topology

DNS provides **name-based access** on top of Kubernetes networking abstractions.

---

## 🧠 Core Mental Model

Kubernetes DNS provides **name resolution, not routing**.

From Kubernetes’ perspective:

- Services and Pods are addressable by name
- DNS resolves names to IPs
- networking handles traffic delivery

DNS answers the question *“Where is it?”*
Networking answers *“How do I get there?”*

---

## 🔁 What Kubernetes DNS Does

Kubernetes DNS:

- runs as a cluster service
- watches the Kubernetes API
- creates DNS records for Services and Pods
- updates records dynamically as objects change

DNS state reflects **current desired connectivity**, not static infrastructure.

---

## 🧭 Service Name Resolution

For Services, DNS provides:

- a stable name
- automatic updates as endpoints change
- indirection from Pod churn

A Service name resolves to:
- the Service virtual IP (ClusterIP)
- not to individual Pod IPs

Clients rely on the Service abstraction, not Pod identity.

---

## 🧱 Namespace Scoping

DNS names are **namespace-scoped**.

Resolution follows this hierarchy:

1. Service name in the same namespace
2. Service name with explicit namespace
3. Fully-qualified domain name (FQDN)

Namespace scoping prevents accidental cross-application coupling.

---

## 🔁 Pod DNS (Conceptual)

Pods may also receive DNS entries:

- typically used for debugging or stateful workloads
- less stable than Service-based discovery
- often disabled or restricted by policy

Pod DNS is **not** a replacement for Services.

---

## 🧠 Search Domains and Resolution Order

Kubernetes configures Pods with:

- DNS search paths
- default cluster domain
- namespace-based resolution

This allows applications to:
- refer to Services by short name
- remain portable across environments

DNS configuration supports abstraction, not convenience hacks.

---

## ⚠️ Common Misunderstandings (Contextual)

> **⚠️ Mistake: Assuming DNS load-balances traffic**  
> DNS resolves names; Services distribute traffic.

> **⚠️ Mistake: Hardcoding Pod IPs or hostnames**  
> This breaks under scaling and restarts.

> **⚠️ Mistake: Using Pod DNS for application discovery**  
> Pod identity is ephemeral.

---

## 🔗 Relationship to Services

DNS and Services are complementary:

- DNS resolves the Service name
- the Service VIP provides a stable endpoint
- Pod networking delivers traffic

Removing any layer breaks the abstraction chain.

---

## 🧭 Reference Context

DNS behavior is visible even in small clusters,
such as the **Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters highlight:
- rapid DNS updates during Pod churn
- reliance on Service indirection
- fragility when abstractions are bypassed

The model remains consistent across environments.

---

## 🔗 Related Networking Docs

- `services-and-virtual-ips.md`  
  Defines the stable endpoints DNS resolves

- `pod-networking-model.md`  
  Defines the connectivity DNS assumes

- `ingress-and-egress.md`  
  Extends discovery to external traffic

- `networkpolicies.md`  
  Restricts which traffic may reach resolved endpoints

DNS is the **naming layer** that makes Kubernetes networking usable.

---
