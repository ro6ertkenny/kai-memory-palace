# 🧭 Kubernetes Networking — Index
*Navigation map for Kubernetes-native networking concepts*

---

## 📌 Purpose

This index provides a **structured navigation map** for the
`k8s/networking` directory.

It answers the question:

> “Where do I start to understand how Kubernetes models connectivity
without mixing in Linux, cloud, or vendor specifics?”

This index is **orientation, not instruction**.

---

## 🧠 How to Think About Kubernetes Networking

Kubernetes networking is about **abstractions and guarantees**, not packets.

Kubernetes promises:
- every Pod has an IP
- Pods can reach other Pods
- Services provide stable virtual endpoints
- DNS resolves Kubernetes objects
- NetworkPolicies express traffic *intent*

How those promises are enforced is **out of scope here**.

---

## 🔁 Recommended Reading Order

Read these documents **in order** to build a correct mental model.

---

### 1️⃣ `README.md`
Defines:
- scope and boundaries of this wing
- what Kubernetes networking *is* and *is not*
- how to use the documents that follow

Start here to align expectations.

---

### 2️⃣ `pod-networking-model.md`
Defines:
- Pod IP assumptions
- flat network model
- Pod-to-Pod reachability guarantees

This is the **keystone document**.
Everything else depends on it.

---

### 3️⃣ `services-and-virtual-ips.md`
Defines:
- Service abstraction
- ClusterIP, NodePort, LoadBalancer intent
- virtual IP behavior and stability

Read this to understand *why Services exist at all*.

---

### 4️⃣ `dns-and-service-discovery.md`
Defines:
- cluster DNS behavior
- name resolution for Services and Pods
- how applications find each other

This connects networking to application behavior.

---

### 5️⃣ `ingress-and-egress.md`
Defines:
- inbound traffic models
- outbound traffic expectations
- how traffic enters and leaves the cluster

This clarifies boundaries between cluster and external networks.

---

### 6️⃣ `networkpolicies.md`
Defines:
- traffic intent expression
- default-allow vs default-deny
- how isolation is modeled in Kubernetes

This is about **policy**, not enforcement mechanics.

---

### 7️⃣ `common-networking-misconceptions.md`
Catalogs:
- frequent misunderstandings
- incorrect mental models
- mistakes that cause real outages

Revisit this often.

---

## 🔗 Relationship to Other Wings

- `k8s/foundations/`  
  Provides the conceptual base Kubernetes networking builds upon

- `k8s/ops+provisioning/`  
  Covers operating and troubleshooting networking components

- `k8s/troubleshooting/`  
  Covers diagnosing real networking failures

- `k8s/ecosystem/`  
  Covers tools that extend networking (Ingress controllers, meshes, etc.)

This wing owns **conceptual clarity**, not operations.

---

## ▶️ How to Use This Index

- New to Kubernetes networking → read top to bottom
- Debugging a concept → jump to the matching abstraction
- Confused during ops → return here to re-anchor

Correct mental models prevent most networking mistakes.

---
