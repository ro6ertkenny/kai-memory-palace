# 🧠 Control Plane Failure Patterns
*Authority-layer symptoms, diagnosis, and safe recovery*

---

## 📌 Purpose

This document catalogs **common control-plane failure patterns** and defines
how operators should **diagnose, contain, and recover** safely.

Control-plane failures are uniquely dangerous because they affect:
- cluster authority
- state consistency
- scheduling and reconciliation
- trust and identity

The goal is not speed, but **preservation of authority and state**.

---

## 🧠 Operator Mental Model

Treat the control plane as **fragile authority**, not just another workload.

- Preserve etcd integrity first
- Maintain API availability
- Avoid mass restarts
- Prefer containment over correction

Loss of authority is worse than temporary unavailability.

---

## 🔁 Common Control Plane Failure Patterns

### ⏳ API Server Unreachable or Timing Out

Likely causes:
- etcd latency or unavailability
- resource exhaustion on control-plane node
- networking issues to API endpoint
- certificate expiration

Initial actions:
- confirm etcd health
- check API server logs
- verify network path
- validate certificates and system time

Avoid:
- restarting all control-plane components simultaneously

---

### 🧠 Controllers Not Reconciling

Likely causes:
- controller-manager crashes
- RBAC misconfiguration
- etcd read/write issues
- API incompatibility after upgrades

Initial actions:
- inspect controller logs
- verify API responsiveness
- check recent RBAC or upgrade activity

Avoid:
- restarting workloads to “force” reconciliation

---

### 🗓️ Scheduler Appears Idle or Ineffective

Likely causes:
- scheduler process failure
- API watch failures
- node readiness or taint issues
- misconfigured admission controllers

Initial actions:
- verify scheduler health
- inspect scheduling events
- confirm node conditions

Avoid:
- assuming worker-node failure prematurely

---

### 🔐 Certificate and Trust Failures

Likely causes:
- expired API server certificates
- kubelet authentication failures
- time drift between nodes
- failed certificate rotation

Initial actions:
- check certificate expiration dates
- validate system clock alignment
- review kubeadm cert status

Avoid:
- regenerating certificates blindly

---

### 🗄️ etcd Degradation or Instability

Likely causes:
- disk pressure
- high write latency
- unclean shutdowns
- quorum loss (multi-node setups)

Initial actions:
- check etcd health and alarms
- assess disk IO and capacity
- stabilize before attempting repair

Avoid:
- restarting etcd without understanding state impact

---

## ⚠️ High-Risk Control Plane Mistakes (Contextual)

> **⚠️ Mistake: Treating control-plane components as stateless**  
> etcd is stateful and authoritative.

> **⚠️ Mistake: Restarting everything to “unstick” the API**  
> This often worsens state corruption.

> **⚠️ Mistake: Ignoring certificate timelines**  
> Many outages are predictable.

---

## 🔁 Safe Recovery Patterns (Conceptual)

Recovery should follow this order:

1. Preserve etcd state
2. Restore API availability
3. Validate controller convergence
4. Confirm scheduler behavior
5. Resume normal operations cautiously

Recovery is complete only after **validation succeeds**.

---

## 🧭 Reference Context

Control-plane failure patterns here are grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters make control-plane failures visible because:
- redundancy is limited
- etcd shares resources
- recovery margins are narrow

The principles documented here remain portable
across environments.

---

## 🔗 Related Troubleshooting Docs

- `symptom-to-domain-diagnosis.md`  
  Maps symptoms to authority-layer failures

- `containment-first-response.md`  
  Defines immediate stabilization actions

- `node-and-runtime-failure-patterns.md`  
  Covers execution-layer failures

- `recovery-and-post-incident-analysis.md`  
  Covers full restoration and learning loops

Together, these documents define **authority-first troubleshooting**.

---
