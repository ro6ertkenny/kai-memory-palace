# 🧭 Cluster-Wide Upgrades — Index
*Navigation map for orchestrated Kubernetes upgrades*

---

## 📌 Purpose

This index provides a **structured navigation map** for the
`k8s/ops+provisioning/upgrades` directory.

It answers the operator question:

> “Where do I go to plan, execute, validate, or recover from a
cluster-wide Kubernetes upgrade?”

This index is **orientation, not instruction**.

---

## 🧠 How to Think About Cluster-Wide Upgrades

Cluster-wide upgrades are about **coordination**, not mechanics.

They require:
- sequencing across domains
- strict version-skew awareness
- explicit validation checkpoints
- predefined rollback paths

Upgrades succeed when **authority, execution, and extensions**
move forward in a controlled order.

---

## 🔁 Lifecycle View

Cluster-wide upgrades follow a deliberate lifecycle:

1. Design the upgrade strategy
2. Validate compatibility boundaries
3. Execute upgrades in sequence
4. Validate at explicit hold points
5. Roll back or recover when necessary

Each document in this directory maps to one or more lifecycle phases.

---

## 🗂️ Document Map

### 📄 `README.md`
Defines:
- scope of cluster-wide upgrades
- relationship to control-plane and worker-node upgrades
- operator ownership and philosophy

Start here to understand *what this directory owns*.

---

### 🧭 `upgrade-strategy-and-sequencing.md`
Covers:
- how to plan upgrades
- sequencing rules and hierarchy
- blast-radius management

Use this when:
- designing an upgrade plan
- deciding upgrade order
- preparing maintenance windows

---

### 🔀 `version-skew-and-compatibility.md`
Covers:
- supported version skew boundaries
- kubelet, control-plane, and add-on compatibility
- common skew-related failure modes

Use this when:
- selecting target versions
- diagnosing subtle post-upgrade failures

---

### 🧩 `addon-and-cni-upgrades.md`
Covers:
- add-on and CNI upgrade coordination
- ecosystem compatibility risks
- execution-layer dependencies

Use this when:
- upgrading networking or storage components
- add-ons fail after a core upgrade

---

### 🛑 `validation-and-hold-points.md`
Covers:
- mandatory validation steps
- explicit go / no-go decisions
- delayed-failure awareness

Use this when:
- deciding whether to proceed
- diagnosing ambiguous symptoms
- protecting rollback options

---

### 🔁 `rollback-and-recovery.md`
Covers:
- rollback vs recovery decisions
- state and trust protection
- controlled restoration paths

Use this when:
- upgrades regress
- stability is lost
- recovery is required

---

## 🔗 Relationship to Other Directories

- `control-plane/`  
  Covers *how* control-plane components are upgraded

- `worker-nodes/`  
  Covers rolling execution-capacity upgrades

- `bootstrap/`  
  Covers initial cluster creation (not upgrades)

- `troubleshooting/`  
  Covers incident response and diagnosis

This directory owns **orchestration and decision-making**,
not component mechanics.

---

## ▶️ How to Use This Index

1. Identify the upgrade phase or failure mode
2. Navigate to the matching document above
3. Read conceptually before acting
4. Validate before proceeding

Cluster-wide upgrades reward **discipline, patience, and evidence**.

---
