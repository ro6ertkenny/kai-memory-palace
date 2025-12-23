# 🧱 Node & Runtime Failure Patterns
*Execution-layer symptoms, diagnosis, and containment*

---

## 📌 Purpose

This document catalogs **common worker-node and container runtime failure
patterns** and defines how operators should **diagnose, contain, and recover**
safely.

Most Kubernetes incidents originate in the **execution layer**:
- nodes
- kubelet
- container runtime
- underlying OS resources

The goal is to restore **predictable execution capacity** without spreading
failure.

---

## 🧠 Operator Mental Model

Treat worker nodes as **replaceable execution units**, not pets.

- Contain first
- Decide repair vs replacement early
- Protect workloads, not nodes
- Prefer isolation over investigation under load

Execution failures should not threaten cluster authority.

---

## 🔁 Common Node & Runtime Failure Patterns

### ⚠️ Node Flapping `Ready / NotReady`

Likely causes:
- kubelet crashes or hangs
- container runtime instability
- network interruptions
- disk or memory pressure
- time drift

Initial actions:
- cordon the node
- inspect kubelet and runtime logs
- check node conditions and pressure

Avoid:
- repeated reboots without diagnosis

---

### 🔁 Pods Restarting or CrashLooping Across a Node

Likely causes:
- runtime failures
- corrupted images or storage
- kernel or cgroup issues
- node-level resource exhaustion

Initial actions:
- identify scope (single node vs cluster-wide)
- inspect runtime logs
- check disk, memory, and inode usage

Avoid:
- deleting workloads to “clear” the issue

---

### ❌ Image Pull Failures

Likely causes:
- network or DNS issues
- registry authentication failures
- runtime misconfiguration

Initial actions:
- verify node connectivity
- inspect image pull errors
- confirm registry access and credentials

Avoid:
- assuming application misconfiguration first

---

### 🧠 Kubelet Unresponsive or Misbehaving

Likely causes:
- configuration drift
- resource starvation
- certificate issues
- runtime dependency failures

Initial actions:
- inspect kubelet logs
- verify configuration consistency
- check cert validity and system time

Avoid:
- restarting kubelet repeatedly without evidence

---

### 💾 Disk, Memory, or PID Pressure

Likely causes:
- unbounded workloads
- log accumulation
- insufficient capacity planning
- filesystem issues

Initial actions:
- identify pressure signals
- stop scheduling on affected nodes
- reclaim or expand capacity

Avoid:
- ignoring pressure warnings until eviction occurs

---

## ⚠️ High-Risk Execution-Layer Mistakes (Contextual)

> **⚠️ Mistake: Treating node instability as a control-plane problem**  
> Diagnose at the execution layer first.

> **⚠️ Mistake: Debugging under live load**  
> Contain before investigating deeply.

> **⚠️ Mistake: Trying to “save” chronically unhealthy nodes**  
> Replacement is often safer and faster.

---

## 🔁 Safe Recovery Patterns (Conceptual)

Recovery should follow this progression:

1. **Contain**
   - cordon and isolate affected nodes
2. **Stabilize**
   - drain workloads if necessary
3. **Decide**
   - repair or replace
4. **Recover**
   - rebuild, rejoin, or restore capacity
5. **Validate**
   - confirm stable execution

Execution recovery prioritizes **capacity and predictability**, not sentiment.

---

## 🧭 Reference Context

Execution-layer failure patterns here are grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters amplify execution failures because:
- capacity is limited
- redundancy is minimal
- recovery paths are narrow

The principles documented here remain portable
across environments.

---

## 🔗 Related Troubleshooting Docs

- `symptom-to-domain-diagnosis.md`  
  Maps symptoms to execution-layer domains

- `containment-first-response.md`  
  Defines immediate stabilization actions

- `control-plane-failure-patterns.md`  
  Covers authority-layer failures

- `recovery-and-post-incident-analysis.md`  
  Covers learning and restoration after incidents

Together, these documents define **execution-layer resilience**.

---
