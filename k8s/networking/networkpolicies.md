# 🔐 NetworkPolicies
*Expressing traffic intent and enforcing isolation in Kubernetes*

---

## 📌 Purpose

This document explains **what NetworkPolicies are**, what they **do and do not**
guarantee, and how operators should reason about traffic isolation in Kubernetes.

NetworkPolicies are frequently misunderstood because they:
- express intent, not enforcement
- apply selectively, not globally
- change default behavior only when present

This document exists to establish **correct mental models**.

---

## 🧠 Core Mental Model

A NetworkPolicy expresses **allowed traffic**, not blocked traffic.

From Kubernetes’ perspective:

- traffic is allowed by default
- NetworkPolicies introduce restrictions
- policies apply only to selected Pods
- enforcement depends on the network stack

NetworkPolicies describe **who may talk to whom**, not *how packets flow*.

---

## 🔁 Default Behavior (Critical)

Before any NetworkPolicies exist:

- all Pods can talk to all other Pods
- all Pods can receive inbound traffic
- all Pods can send outbound traffic

NetworkPolicies do **nothing** until they are applied.

---

## 🧱 What a NetworkPolicy Targets

A NetworkPolicy applies to:

- Pods (via selectors)
- within a namespace (by default)
- for ingress, egress, or both

It does **not**:
- apply to Nodes
- apply cluster-wide automatically
- affect Services directly

Policies attach to Pods, not endpoints.

---

## 🔀 Ingress vs Egress Policies

### Ingress Policies
Define **who can send traffic to a Pod**.

Once an ingress policy selects a Pod:
- all inbound traffic is denied by default
- only explicitly allowed sources may connect

Ingress policies implement **default-deny** behavior *per Pod*.

---

### Egress Policies
Define **where a Pod may send traffic**.

Once an egress policy selects a Pod:
- all outbound traffic is denied by default
- only explicitly allowed destinations are reachable

Egress control is optional and must be intentional.

---

## 🧭 Policy Scope and Selectors

Policies use selectors to define intent:

- Pod selectors
- namespace selectors
- IP blocks

Selectors express **logical relationships**, not network topology.

Correct selectors matter more than rule count.

---

## ⚠️ Common Misunderstandings (Contextual)

> **⚠️ Mistake: Assuming NetworkPolicies are global firewalls**  
> Policies apply only to selected Pods.

> **⚠️ Mistake: Expecting enforcement without CNI support**  
> Enforcement depends on the networking implementation.

> **⚠️ Mistake: Applying a policy without realizing it flips defaults**  
> Default-deny surprises are common.

---

## 🔁 Relationship to Services and DNS

NetworkPolicies:
- do not replace Services
- do not resolve names
- operate at the Pod-to-Pod level

Allowing DNS traffic explicitly is often required
once policies are in place.

Policy design must account for **infrastructure dependencies**.

---

## 🧠 Policy Design Philosophy

Effective NetworkPolicies:
- start simple
- isolate incrementally
- prefer explicit allow rules
- are validated under real traffic

Overly complex policies increase outage risk.

---

## 🧭 Reference Context

NetworkPolicy behavior is visible even in small clusters,
such as the **Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters highlight:
- default-deny effects clearly
- policy misconfigurations immediately
- dependency on DNS and Services

The conceptual model remains portable across environments.

---

## 🔗 Related Networking Docs

- `pod-networking-model.md`  
  Defines the connectivity assumptions policies restrict

- `services-and-virtual-ips.md`  
  Provides stable endpoints policies indirectly protect

- `dns-and-service-discovery.md`  
  Must be explicitly allowed under restrictive policies

- `ingress-and-egress.md`  
  Defines traffic direction policies control

NetworkPolicies are the **language of trust and isolation** in Kubernetes.

---
