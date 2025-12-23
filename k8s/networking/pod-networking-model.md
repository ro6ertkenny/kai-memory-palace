# 🧩 Pod Networking Model
*The foundational assumptions Kubernetes makes about connectivity*

---

## 📌 Purpose

This document defines the **Pod networking model** that all Kubernetes
networking abstractions depend on.

If this model is misunderstood, everything built on top of it
(Services, DNS, Ingress, NetworkPolicies) becomes confusing.

This is the **keystone document** of the networking wing.

---

## 🧠 Core Mental Model

Kubernetes assumes a **flat, routable Pod network**.

From Kubernetes’ perspective:

- Every Pod gets its own IP address
- Every Pod IP is reachable from every other Pod IP
- Pods can communicate without NAT
- Nodes do not need to be aware of application topology

How this is implemented is not Kubernetes’ concern.
The **guarantee** is what matters.

---

## 🔁 The Three Non-Negotiable Assumptions

Kubernetes networking is built on three assumptions:

### 1️⃣ Pods can communicate with all other Pods
- No address translation required
- No port mapping required
- No proxies required by default

This enables simple application assumptions.

---

### 2️⃣ Nodes can communicate with all Pods
- kubelet, kube-proxy, and control-plane components rely on this
- health checks and status reporting depend on it

If nodes cannot reach Pods, the cluster cannot function reliably.

---

### 3️⃣ Pods see their own IP as their identity
- a Pod’s IP is stable for its lifetime
- applications bind directly to the Pod IP
- Kubernetes does not expect applications to be network-aware

This is why Pods are ephemeral but IPs are not reused within a Pod’s lifetime.

---

## 🧭 Why Kubernetes Chooses This Model

This model enables:

- simple application networking assumptions
- portability across environments
- separation of concerns between platform and workloads
- consistent behavior regardless of infrastructure

Without this model, Kubernetes would leak infrastructure complexity upward.

---

## 🔗 Relationship to Other Kubernetes Objects

### Pods
- The Pod is the **unit of networking**
- Containers in a Pod share:
  - IP address
  - network namespace
  - localhost

This is why Pods, not containers, are scheduled.

---

### Services
- Services do **not** replace Pod networking
- Services provide **stable virtual endpoints**
- Pod-to-Pod networking still underpins Services

Services exist because Pods are ephemeral.

---

### DNS
- DNS resolves Services and Pods
- DNS does not route traffic
- DNS relies on the Pod networking model to work

Name resolution assumes connectivity.

---

### Ingress & Egress
- Ingress builds on Services
- Egress assumes Pod IP reachability
- Traffic control assumes the flat Pod network

Ingress is not a replacement for Pod networking.

---

## ⚠️ Common Misunderstandings (Contextual)

> **⚠️ Mistake: Assuming Pods are behind NAT**  
> Kubernetes networking assumes direct reachability.

> **⚠️ Mistake: Treating Nodes as routers for Pods**  
> Kubernetes abstracts this away.

> **⚠️ Mistake: Expecting Pod IPs to persist beyond Pod lifetime**  
> Pods are ephemeral; Services provide stability.

---

## 🧠 What Kubernetes Does *Not* Define

Kubernetes does not specify:
- how IPs are allocated
- how routing is implemented
- how traffic is encrypted
- how isolation is enforced

Those are delegated to the **CNI implementation**.

Kubernetes defines the **contract**, not the mechanism.

---

## 🧭 Reference Context

This Pod networking model is visible even in small clusters,
such as the **Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters make violations obvious because:
- routing failures surface immediately
- misconfigurations break core guarantees
- abstractions are easier to reason about

The model remains consistent across environments.

---

## 🔗 Related Networking Docs

- `services-and-virtual-ips.md`  
  Builds stable endpoints on top of Pod networking

- `dns-and-service-discovery.md`  
  Resolves names that rely on Pod reachability

- `ingress-and-egress.md`  
  Controls how traffic enters and exits the Pod network

- `networkpolicies.md`  
  Restricts traffic *within* the Pod network

All higher-level networking concepts assume this model holds.

---
