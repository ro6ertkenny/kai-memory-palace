# 🧭 Control Plane — Index
*Navigation map for control-plane operations*

---

## 📌 Purpose

This index provides a **structured navigation map** for the
`k8s/ops+provisioning/control-plane` directory.

It answers the operator question:

> “Where do I look when something goes wrong in the control plane — or when I
need to reason about its lifecycle?”

This index is **orientation, not instruction**.

---

## 🧠 How to Think About the Control Plane

The control plane represents **cluster authority**.

It is responsible for:
- identity and trust
- state durability
- reconciliation and convergence
- API availability
- safe evolution over time

Failures in the control plane are **systemic**, not localized.

---

## 🔁 Lifecycle View

Control-plane responsibilities follow a lifecycle:

1. Establish authority after bootstrap
2. Maintain health and trust
3. Detect and diagnose degradation
4. Upgrade safely
5. Recover deterministically from failure

The documents in this directory map directly to that lifecycle.

---

## 🗂️ Document Map

### 📄 `README.md`
Defines:
- control-plane scope
- lifecycle ownership
- boundary with bootstrap

Start here if you are new to control-plane operations.

---

### 🔐 `certificates-and-trust.md`
Covers:
- certificate authority ownership
- authentication and identity
- expiration and rotation risk

Use this when:
- API auth behaves strangely
- components fail without clear errors
- time-based failures appear

---

### 🗄️ `etcd-health-and-recovery.md`
Covers:
- etcd health signals
- quorum and durability
- backup and recovery principles

Use this when:
- API latency spikes
- state behaves inconsistently
- recovery or restore is required

---

### 🌐 `api-server-availability-and-performance.md`
Covers:
- API responsiveness
- performance degradation
- safe incident response

Use this when:
- kubectl hangs or times out
- controllers or scheduler stall
- cluster-wide slowness appears

---

### 🧭 `scheduler-and-controller-behavior.md`
Covers:
- scheduling decisions
- reconciliation loops
- convergence health

Use this when:
- Pods remain Pending
- desired state is not converging
- controllers appear idle or overloaded

---

### ⬆️ `control-plane-upgrades.md`
Covers:
- upgrade sequencing
- validation discipline
- rollback and recovery considerations

Use this when:
- planning or executing upgrades
- diagnosing post-upgrade instability
- coordinating multi-component changes

---

## 🔗 Relationship to Other Directories

- `bootstrap/`  
  Covers how the control plane is **created**

- `worker-nodes/`  
  Covers how execution capacity is added and maintained

- `upgrades/`  
  Covers cluster-wide upgrades beyond the control plane

- `troubleshooting/`  
  Provides incident-response frameworks and diagnostics

This directory owns **authority and state**, not general operations.

---

## ▶️ How to Use This Index

1. Identify the symptom or task
2. Locate the corresponding document above
3. Read conceptually before taking action
4. Validate after every change

Control-plane work rewards **discipline and patience**.

---
