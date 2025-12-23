# 🚪 Ingress & Egress
*How traffic enters and leaves a Kubernetes cluster*

---

## 📌 Purpose

This document explains **how Kubernetes models traffic at the cluster boundary**:
- inbound traffic (**Ingress**)
- outbound traffic (**Egress**)

Ingress and Egress do not replace Services or Pod networking.
They **build on top of them** to define how the cluster interacts
with external systems.

---

## 🧠 Core Mental Model

Think in terms of **direction and intent**, not devices.

- **Ingress** defines *how external traffic reaches Services*
- **Egress** defines *how Pods reach external destinations*

Kubernetes models **intent and policy**.
It does not mandate specific enforcement mechanisms.

---

## 🔁 Ingress (Inbound Traffic)

Ingress models **external → cluster** traffic.

Conceptually, Ingress:
- routes HTTP(S) requests
- terminates TLS (often)
- selects backend Services
- applies rules based on hostnames and paths

Ingress does **not**:
- replace Services
- expose Pods directly
- define how packets are forwarded

Ingress expresses **routing intent**, not implementation.

---

## 🧱 Ingress Objects vs Ingress Controllers

Important distinction:

- **Ingress object**  
  Declarative rules stored in the API

- **Ingress controller**  
  A component that enforces those rules

Kubernetes defines the object.
The controller provides the behavior.

This separation preserves portability.

---

## 🔗 Relationship to Services

Ingress always targets **Services**, not Pods.

Flow:
1. External request arrives
2. Ingress rules match host/path
3. Traffic is forwarded to a Service
4. Service selects backend Pods

Ingress depends on:
- Services for stability
- Pod networking for delivery
- DNS for name resolution

---

## 🔁 Egress (Outbound Traffic)

Egress models **cluster → external** traffic.

Kubernetes itself assumes:
- Pods can reach external networks
- outbound traffic is allowed by default

Egress control is **optional and policy-driven**.

---

## 🧠 Egress Control (Conceptual)

Egress intent may include:
- restricting destinations
- enforcing least privilege
- auditing outbound connections

Kubernetes expresses egress intent primarily through:
- NetworkPolicies
- namespace-level isolation

How egress is enforced depends on the networking stack.

---

## ⚠️ Common Misunderstandings (Contextual)

> **⚠️ Mistake: Treating Ingress as a load balancer**  
> Ingress routes traffic; Services distribute it.

> **⚠️ Mistake: Expecting Egress control by default**  
> Kubernetes defaults to allow-all.

> **⚠️ Mistake: Mixing cloud load balancers with Ingress concepts**  
> Ingress is platform-agnostic.

---

## 🔁 Boundary Responsibility Split

Kubernetes owns:
- routing intent
- service selection
- policy expression

Infrastructure owns:
- packet forwarding
- encryption mechanisms
- performance characteristics

Clear separation prevents abstraction leakage.

---

## 🧭 Reference Context

Ingress and Egress behavior is visible even in small clusters,
such as the **Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters clarify:
- abstraction boundaries
- dependency on Services
- policy effects on connectivity

The conceptual model remains consistent across environments.

---

## 🔗 Related Networking Docs

- `services-and-virtual-ips.md`  
  Defines stable endpoints Ingress targets

- `dns-and-service-discovery.md`  
  Resolves hostnames used in routing rules

- `networkpolicies.md`  
  Controls allowed ingress and egress traffic

Ingress and Egress define **how the cluster meets the outside world**.

---
