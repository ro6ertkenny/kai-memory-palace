# 🛑 Validation & Hold Points
*Explicit go / no-go decisions during cluster-wide upgrades*

---

## 📌 Purpose

This document defines **mandatory validation steps and decision checkpoints**
(“hold points”) during cluster-wide Kubernetes upgrades.

Upgrades fail most often not because of a bad change,
but because operators **proceed without evidence**.

Hold points exist to:
- surface regressions early
- preserve rollback options
- prevent cascading failures
- replace momentum with judgment

---

## 🧠 Operator Mental Model

Think of validation as **proof**, not reassurance.

- Commands completing ≠ system health
- Passing health checks ≠ workload correctness
- Silence ≠ stability

A hold point requires **evidence** before proceeding.

---

## 🔁 Where Hold Points Occur

Hold points must exist **between every upgrade phase**:

1. After preparation
2. After control-plane upgrade
3. After each worker-node batch
4. After add-on upgrades
5. After final convergence

Skipping a hold point converts a controlled upgrade
into an uncontrolled experiment.

---

## 🔍 What to Validate (Conceptual)

Validation should answer these questions:

### Authority & State
- Is the API responsive and stable?
- Are controllers reconciling?
- Is etcd healthy with acceptable latency?

### Execution
- Are workloads scheduling and starting?
- Are Pods running without abnormal restarts?
- Are nodes stable and reporting correctly?

### Networking & Storage
- Does DNS resolve inside the cluster?
- Do Services route traffic?
- Do volumes attach and mount correctly?

### Time & Trust
- Are certificates valid?
- Are there authentication or authorization anomalies?
- Is time synchronized across nodes?

Validation must reflect **real workload behavior**, not just system components.

---

## 🛑 Hold Point Decisions

At each hold point, operators must choose one of three actions:

### ▶️ Proceed
Evidence shows:
- stability
- convergence
- no unexplained anomalies

### ⏸ Pause
Evidence is ambiguous:
- partial failures
- delayed symptoms
- unexplained noise

Pausing preserves options.

### 🔁 Roll Back / Recover
Evidence shows:
- clear regression
- loss of stability
- trust or state violations

Rollback is a **success outcome**, not a failure.

---

## ⚠️ Common Validation Failures (Contextual)

> **⚠️ Mistake: Treating kubeadm or package success as validation**  
> Tool success does not equal system health.

> **⚠️ Mistake: Validating only control-plane components**  
> Execution failures often surface at the workload layer.

> **⚠️ Mistake: Rushing because “the window is open”**  
> Time pressure increases recovery cost.

---

## 🔁 Delayed Failure Awareness

Some failures appear **after** the apparent success window.

Operators must:
- observe the cluster for a stability period
- watch for resource pressure
- monitor controller backlog
- review logs for recurring warnings

Delayed failures are common after:
- API changes
- add-on upgrades
- CRD migrations

---

## 🧭 Reference Context

Validation and hold-point discipline documented here is grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters surface failures quickly because:
- margins are thin
- redundancy is limited
- convergence issues are visible

The principles documented here remain portable
across environments.

---

## 🔗 Related Upgrade Docs

- `README.md`  
  Defines cluster-wide upgrade ownership

- `upgrade-strategy-and-sequencing.md`  
  Defines when hold points occur

- `version-skew-and-compatibility.md`  
  Defines boundaries that validation must respect

- `addon-and-cni-upgrades.md`  
  Highlights add-on-specific validation needs

Together, these documents define **evidence-driven upgrades**.

---
