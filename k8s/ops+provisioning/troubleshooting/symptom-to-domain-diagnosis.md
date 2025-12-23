# 🧭 Symptom → Domain Diagnosis
*Mapping observable failures to the correct root-cause layer*

---

## 📌 Purpose

This document defines a **symptom-first diagnostic framework** for Kubernetes
troubleshooting.

Most incidents escalate because operators:
- chase symptoms instead of domains
- change multiple variables simultaneously
- fix the wrong layer first

This framework exists to answer one question quickly and reliably:

> “Which failure domain should I investigate first?”

---

## 🧠 Operator Mental Model

Think in **layers**, not components.

- Symptoms surface at the workload or API layer
- Root causes almost always live lower
- Fixing the wrong layer increases blast radius

Diagnosis precedes action.

---

## 🔁 Diagnostic Flow (High-Level)

1. Observe symptoms
2. Classify the symptom pattern
3. Map the pattern to a likely domain
4. Validate domain signals
5. Contain before correcting

Skipping steps converts troubleshooting into guesswork.

---

## 🔍 Common Symptom Patterns → Likely Domains

### 🧱 Pods Stuck in `Pending`

Likely domains:
- **Scheduling / Control plane**
- **Resource availability**
- **Networking (CNI not ready)**

Initial checks:
- node readiness and capacity
- taints, tolerations, and affinity
- scheduler events

Avoid:
- restarting kubelet immediately

---

### 🔁 Pods in `CrashLoopBackOff`

Likely domains:
- **Container runtime**
- **Application configuration**
- **Node resource pressure**

Initial checks:
- container logs and exit codes
- recent node changes
- memory and disk pressure

Avoid:
- draining the node before confirming scope

---

### ❌ Pods Fail to Start or Pull Images

Likely domains:
- **Container runtime**
- **Networking / DNS**
- **Registry access or auth**

Initial checks:
- image pull errors
- node network connectivity
- runtime logs

Avoid:
- assuming application-level failure

---

### ⚠️ Nodes Flapping `Ready / NotReady`

Likely domains:
- **kubelet**
- **Networking**
- **Resource exhaustion**
- **Time synchronization**

Initial checks:
- kubelet logs
- node conditions
- disk, memory, and CPU pressure

Avoid:
- reboot loops without diagnosis

---

### ⏳ API Requests Timing Out

Likely domains:
- **Control plane**
- **etcd**
- **Networking**

Initial checks:
- API server health
- etcd latency and errors
- network path to API endpoint

Avoid:
- touching worker nodes first

---

### 🧠 Controllers Not Reconciling

Likely domains:
- **Control plane**
- **etcd**
- **RBAC / permissions**

Initial checks:
- controller-manager logs
- etcd health
- recent RBAC changes

Avoid:
- restarting workloads as a first step

---

### 🌐 Networking Appears Broken

Likely domains:
- **CNI**
- **kube-proxy**
- **Node networking**

Initial checks:
- CNI pod status
- DNS resolution inside Pods
- node-to-node connectivity

Avoid:
- assuming application misconfiguration

---

### 🔐 Authentication / Authorization Failures

Likely domains:
- **Certificates and trust**
- **RBAC**
- **Time drift**

Initial checks:
- certificate expiration
- recent cert rotation
- system clock alignment

Avoid:
- regenerating certs blindly

---

## ⚠️ High-Risk Misclassification Patterns

> **⚠️ Mistake: Treating application crashes as cluster failures**  
> Always confirm cluster health first.

> **⚠️ Mistake: Restarting components before observing logs**  
> Evidence disappears quickly.

> **⚠️ Mistake: Fixing symptoms at the surface layer**  
> Root causes live deeper.

---

## 🔁 Validation Before Action

Before making changes:
- confirm the domain hypothesis
- limit the scope of intervention
- ensure rollback or containment paths exist

Correct diagnosis reduces recovery time more than any tool.

---

## 🧭 Reference Context

Symptom-to-domain mappings here are grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters make domain misclassification obvious because:
- failures propagate quickly
- capacity is limited
- recovery margins are narrow

The principles documented here remain portable
across environments.

---

## 🔗 Related Troubleshooting Docs

- `README.md`  
  Defines troubleshooting philosophy and scope

- `containment-first-response.md`  
  Covers stabilizing the system before fixing

- `control-plane-failure-patterns.md`  
  Deep dive into authority-layer failures

- `node-and-runtime-failure-patterns.md`  
  Covers execution-layer failures

Together, these documents define **diagnosis before intervention**.

---
