# 🔗 Services & Virtual IPs
*Stable connectivity on top of ephemeral Pods*

---

## 📌 Purpose

This document explains **why Kubernetes Services exist** and how
**virtual IPs provide stability** in an otherwise ephemeral system.

Pods come and go.
IPs change.
Applications still need reliable endpoints.

Services solve this problem.

---

## 🧠 Core Mental Model

A Kubernetes Service is a **stable virtual endpoint** that represents
a **dynamic set of Pods**.

From Kubernetes’ perspective:

- Pods are ephemeral
- IPs are short-lived
- Services provide continuity
- Clients talk to Services, not Pods

Services are **indirection**, not routing magic.

---

## 🔁 What a Service Is (Conceptually)

A Service provides:

- a stable virtual IP (VIP)
- a stable DNS name
- a selector that matches Pods
- a policy for traffic distribution

A Service does **not**:
- run application code
- proxy traffic itself
- guarantee load-balancing fairness

It represents **intent**, not implementation.

---

## 🧭 Why Services Are Necessary

Without Services:

- clients would need to track Pod IPs
- restarts would break connectivity
- scaling would require reconfiguration
- failures would ripple outward

Services decouple:
- *who* needs access  
from  
- *which* Pods currently provide it

---

## 🧱 Service Types (Intent, Not Mechanics)

### ClusterIP
- default Service type
- provides an internal virtual IP
- reachable only inside the cluster

Used for:
- internal application communication
- control-plane components
- backend services

---

### NodePort
- exposes a Service on each Node’s IP
- provides a fixed port across nodes
- primarily for simple or transitional use

NodePort is **not a production ingress solution**.
It is an exposure primitive.

---

### LoadBalancer
- exposes a Service externally
- integrates with external infrastructure
- still backed by a Service abstraction

LoadBalancer does not change the Service model.
It adds **external reachability**.

---

## 🔁 Virtual IP Behavior

The Service virtual IP:

- is stable for the life of the Service
- does not belong to a Pod
- is not tied to a specific node
- represents a logical endpoint

Traffic sent to the VIP is distributed
to matching Pods according to policy.

---

## 🔗 Relationship to Pod Networking

Services rely on the **Pod networking model**:

- Pods must be reachable
- routing must be possible
- IPs must be routable cluster-wide

Services do not replace Pod networking.
They **depend on it**.

---

## 🧠 kube-proxy (High-Level Only)

At a high level:

- kube-proxy observes Services and Endpoints
- it programs rules to implement Service behavior

The **mechanism is deliberately abstracted**.
What matters is the behavior:
- stable access
- dynamic backend membership

---

## ⚠️ Common Misunderstandings (Contextual)

> **⚠️ Mistake: Treating Services as load balancers**  
> Services provide indirection, not guarantees.

> **⚠️ Mistake: Addressing Pods directly in applications**  
> This breaks under scaling and restarts.

> **⚠️ Mistake: Assuming Service IPs are real hosts**  
> VIPs are logical constructs.

---

## 🧭 Reference Context

Service behavior is visible even in small clusters,
such as the **Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters highlight:
- Service indirection clearly
- Pod churn effects
- dependency on correct Pod networking

The abstraction remains consistent at all scales.

---

## 🔗 Related Networking Docs

- `pod-networking-model.md`  
  Defines the connectivity assumptions Services rely on

- `dns-and-service-discovery.md`  
  Explains how Services are resolved by name

- `ingress-and-egress.md`  
  Builds external traffic flows on top of Services

- `networkpolicies.md`  
  Restricts traffic to and from Services

Services are the **hinge** between ephemeral execution
and stable communication.

---
