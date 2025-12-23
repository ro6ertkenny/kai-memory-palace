# 🔁 Rollback & Recovery
*Controlled exits, state protection, and decisive restoration*

---

## 📌 Purpose

This document defines **operator responsibility for rolling back and recovering
from cluster-wide Kubernetes upgrades**.

Rollback is not failure.
Rollback is **evidence of control**.

This document exists to ensure operators can:
- stop upgrades safely
- restore stability without compounding damage
- preserve cluster trust and state
- return to a known-good baseline

---

## 🧠 Operator Mental Model

Think of rollback as a **pre-planned exit**, not an improvisation.

- You decide *when to stop*
- You know *how to restore*
- You protect *state and trust first*

Upgrades that cannot be rolled back safely
**should not be started**.

---

## 🔁 Rollback vs Recovery

These terms are related but distinct:

### 🔄 Rollback
- Reverting to a previous version or configuration
- Used when regressions are detected early
- Preserves cluster identity and state

### 🧯 Recovery
- Restoring from backups or snapshots
- Used when state or trust is compromised
- May involve partial rebuilds or replacement

Operators must recognize **which scenario they are in**.

---

## 🧭 Rollback Boundaries (What Can and Cannot Be Reverted)

Rollback feasibility depends on what changed:

- **Control plane versions**  
  Often reversible within supported skew windows

- **Worker node upgrades**  
  Easily rolled back or replaced

- **Add-on upgrades**  
  Frequently reversible, but may require CRD handling

- **API removals or migrations**  
  Often irreversible without recovery

Knowing these boundaries **before upgrading** is critical.

---

## 🔐 Protecting State During Rollback

State protection priorities:

1. etcd integrity
2. certificate and trust continuity
3. workload data persistence

During rollback:
- avoid write-heavy operations
- prevent repeated restarts
- isolate changes to the smallest possible scope

State corruption is worse than downtime.

---

## 🔁 Recovery Scenarios (Conceptual)

Recovery may be required when:

- etcd state is corrupted
- certificates are invalid or lost
- API behavior is undefined
- cluster identity is compromised

Recovery paths include:
- restoring etcd from snapshot
- rebuilding control-plane nodes
- replacing worker nodes
- re-establishing trust chains

Recovery is **deliberate, not fast**.

---

## ⚠️ Common Rollback & Recovery Failures (Contextual)

> **⚠️ Mistake: Continuing an upgrade hoping issues will “settle”**  
> Delayed rollback increases blast radius.

> **⚠️ Mistake: Rolling back without understanding state impact**  
> Version rollback does not undo state mutations.

> **⚠️ Mistake: Mixing rollback with new changes**  
> Recovery must be isolated and controlled.

---

## ❤️ Validation After Rollback or Recovery

After rollback or recovery, operators must validate:

- API availability and correctness
- controller and scheduler convergence
- workload execution and stability
- certificate validity and trust
- absence of recurring error patterns

Rollback is complete only when **validation passes**.

---

## 🧭 Reference Context

Rollback and recovery practices documented here are grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters highlight rollback discipline because:
- margins are thin
- recovery paths are narrow
- mistakes surface immediately

The principles documented here remain portable
across environments.

---

## 🔗 Related Upgrade Docs

- `README.md`  
  Defines cluster-wide upgrade scope and ownership

- `upgrade-strategy-and-sequencing.md`  
  Defines when rollback must be possible

- `validation-and-hold-points.md`  
  Defines decision checkpoints triggering rollback

- `control-plane/control-plane-upgrades.md`  
  Covers component-level rollback considerations

Together, these documents define **safe exits as part of upgrade success**.

---
