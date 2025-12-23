# ⚠️ Common Networking Misconceptions
*Incorrect mental models that cause real Kubernetes outages*

---

## 📌 Purpose

This document catalogs **high-frequency networking misconceptions** in Kubernetes
and replaces them with **correct mental models**.

Most networking incidents are not caused by bugs.
They are caused by **incorrect assumptions** carried over from:
- traditional networking
- cloud-provider abstractions
- VM-based architectures

This document exists to stop those assumptions early.

---

## 🧠 How to Use This Document

Read this document:
- after learning the networking abstractions
- before operating or troubleshooting networking
- whenever behavior feels “mysterious”

If something seems confusing, there is usually a **broken assumption** underneath.

---

## ❌ Misconception: Pods Are Behind NAT

**Incorrect model:**  
Pods sit behind node NAT and require port mapping.

**Correct model:**  
Pods have routable IPs and can reach each other directly.

**Why this matters:**  
- Applications should bind normally
- Services exist for stability, not reachability
- NAT assumptions break debugging and design

---

## ❌ Misconception: Services Are Load Balancers

**Incorrect model:**  
Services distribute traffic evenly and intelligently.

**Correct model:**  
Services provide **indirection and stability**, not guarantees.

**Why this matters:**  
- Load distribution depends on implementation
- Services are not traffic-aware
- Fairness and retries belong at higher layers

---

## ❌ Misconception: DNS Routes Traffic

**Incorrect model:**  
DNS sends traffic to the right Pod.

**Correct model:**  
DNS resolves names to IPs.
Networking delivers traffic.

**Why this matters:**  
- DNS issues ≠ networking issues
- Fixing DNS does not fix routing
- Troubleshooting starts in the correct layer

---

## ❌ Misconception: Ingress Replaces Services

**Incorrect model:**  
Ingress exposes Pods directly.

**Correct model:**  
Ingress routes traffic **to Services**, not Pods.

**Why this matters:**  
- Services remain mandatory
- Ingress depends on Service behavior
- Removing Services breaks routing

---

## ❌ Misconception: NetworkPolicies Block Traffic Automatically

**Incorrect model:**  
NetworkPolicies are global firewalls.

**Correct model:**  
NetworkPolicies:
- apply only to selected Pods
- change default behavior only when present
- require CNI enforcement support

**Why this matters:**  
- Policies can silently do nothing
- Policies can unexpectedly deny traffic
- Isolation must be intentional

---

## ❌ Misconception: Kubernetes Networking Is Cloud Networking

**Incorrect model:**  
Kubernetes networking behaves like cloud VPC networking.

**Correct model:**  
Kubernetes networking is **platform-agnostic** and abstraction-driven.

**Why this matters:**  
- Cloud specifics are implementation details
- Designs should remain portable
- Cloud assumptions leak abstraction boundaries

---

## ❌ Misconception: Nodes Are the Networking Unit

**Incorrect model:**  
Nodes route traffic for applications.

**Correct model:**  
Pods are the networking unit.
Nodes host Pods.

**Why this matters:**  
- Debugging should focus on Pods
- Policies apply to Pods
- Node-centric thinking misleads diagnosis

---

## ❌ Misconception: Egress Is Controlled by Default

**Incorrect model:**  
Outbound traffic is restricted unless allowed.

**Correct model:**  
Kubernetes defaults to **allow-all egress**.

**Why this matters:**  
- Data exfiltration risk exists by default
- Egress control must be explicit
- Policies must include DNS and dependencies

---

## 🧠 Pattern Behind the Mistakes

Most networking misconceptions come from:
- assuming infrastructure behavior
- expecting implicit security
- treating abstractions as implementations

Kubernetes networking rewards **explicit intent and correct layering**.

---

## 🧭 Reference Context

These misconceptions are especially visible in small clusters,
such as the **Raspberry Pi Kubernetes cluster** reference implementation.

Small environments expose:
- abstraction violations immediately
- policy misconfigurations clearly
- incorrect assumptions quickly

The lessons apply at all scales.

---

## 🔗 Related Networking Docs

- `pod-networking-model.md`  
  Establishes the foundational assumptions

- `services-and-virtual-ips.md`  
  Explains stability vs load distribution

- `dns-and-service-discovery.md`  
  Separates naming from routing

- `ingress-and-egress.md`  
  Clarifies boundary intent

- `networkpolicies.md`  
  Defines isolation semantics

Correct networking starts with **correct assumptions**.

---

