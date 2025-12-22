# 🧭 Worker Nodes — Index
*Navigation map for worker-node operations*

---

## 📌 Purpose

This index provides a **structured navigation map** for the
`k8s/ops+provisioning/worker-nodes` directory.

It answers the operator question:

> “Where do I go when something is wrong with execution capacity,
or when I need to safely intervene on worker nodes?”

This index is **orientation, not instruction**.

---

## 🧠 How to Think About Worker Nodes

Worker nodes represent **execution capacity**, not authority.

They are responsible for:
- running workloads
- enforcing resource limits
- reporting execution health
- absorbing operational churn

Worker nodes are designed to be:
- replaceable
- maintainable
- isolated from cluster authority

Healthy clusters assume **worker nodes will fail**.

---

## 🔁 Lifecycle View

Worker-node responsibilities follow a predictable lifecycle:

1. Prepare and join the cluster
2. Execute workloads reliably
3. Manage pressure and resources
4. Undergo maintenance and upgrades
5. Fail, recover, or be replaced

The documents in this directory map directly to this lifecycle.

---

## 🗂️ Document Map

### 📄 `README.md`
Defines:
- worker-node scope and philosophy
- Day-1 vs Day-2 responsibilities
- relationship to control plane and bootstrap

Start here if you are new to worker-node operations.

---

### 🧠 `kubelet-and-node-agent.md`
Covers:
- kubelet responsibilities and boundaries
- node-level authority and reporting
- common kubelet failure patterns

Use this when:
- nodes flap Ready / NotReady
- Pods fail to execute correctly
- execution diverges from scheduling intent

---

### 🔗 `node-join-lifecycle.md`
Covers:
- end-to-end node join phases
- identity, trust, and readiness
- common join failure patterns

Use this when:
- nodes join but never become Ready
- kubeadm joins behave inconsistently
- new capacity is unreliable

---

### ⚙️ `runtime-and-resource-management.md`
Covers:
- container runtime behavior
- resource pressure and eviction
- capacity reporting discipline

Use this when:
- Pods restart unexpectedly
- nodes experience memory or disk pressure
- execution failures look non-deterministic

---

### 🧰 `draining-and-maintenance.md`
Covers:
- cordoning and draining discipline
- safe workload movement
- planned maintenance workflows

Use this when:
- performing node maintenance
- preparing for upgrades
- isolating problematic nodes

---

### ⬆️ `node-upgrades.md`
Covers:
- rolling upgrade sequencing
- validation and rollback
- upgrade-related failure patterns

Use this when:
- upgrading kubelet, runtime, or OS
- planning rolling changes
- diagnosing post-upgrade instability

---

### 🧯 `node-failure-and-recovery.md`
Covers:
- failure detection and categorization
- repair vs replacement decisions
- controlled recovery sequences

Use this when:
- nodes fail unexpectedly
- execution capacity degrades
- rapid recovery is required

---

## 🔗 Relationship to Other Directories

- `bootstrap/`  
  Covers how worker nodes initially join the cluster

- `control-plane/`  
  Covers authority, state, and scheduling decisions

- `upgrades/`  
  Covers cluster-wide upgrade strategy

- `troubleshooting/`  
  Provides incident-response frameworks and diagnostics

This directory owns **execution and capacity**, not cluster authority.

---

## ▶️ How to Use This Index

1. Identify the symptom or task
2. Locate the matching document above
3. Read conceptually before acting
4. Validate after every intervention

Worker-node operations reward **decisive, disciplined action**.

---
