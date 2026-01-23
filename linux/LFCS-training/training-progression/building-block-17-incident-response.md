# 🧱 Building Block 17 — Incident Response

**Path:** `linux/LFCS-training/training-progression/building-block-17-incident-response.md`  
**Purpose:** Build the ability to **handle multi-domain incidents** using **operator playbooks**, choosing the right flow, executing safely, and verifying recovery under pressure.

---

## 🎯 What This Block Builds

You are building:

- The ability to:
  - triage ambiguous symptoms
  - choose the **correct playbook**
  - execute a **safe, ordered recovery**
- The habit of:
  - stabilizing first
  - diagnosing before changing
  - verifying after every action

This block turns “everything is broken” into a **structured, controlled response**.

---

## 🧠 Mental Models You Must Own

- Incidents are:
  - rarely single-domain
  - often cascades (storage → services → processes → network symptoms)
- The correct response is:
  - not to “fix everything”
  - but to **identify the primary failure**
- Playbooks are:
  - algorithms
  - not suggestions
- Verification is:
  - part of the fix
  - not optional

Invariants:

- “I always stabilize before optimizing.”
- “I choose the playbook that matches the **root symptom**, not the loudest one.”
- “Every action must have a verification step.”

---

## 🛠️ Canonical Drill Surfaces

You must be fluent with **all** prior drill surfaces, especially:

- `linux/LFCS-training/execution-drills/essential-commands.md`
- `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/networking.md`
- `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- `linux/LFCS-training/execution-drills/security-and-selinux.md`

Rule:

> At this stage, drills are assumed knowledge. You are training **decision-making and flow control**.

---

## 🧪 Canonical Failure Scenarios

These are the primary practice inputs for this block:

- `linux/LFCS-training/failure-scenarios/scenario-1-system-feels-slow.md`
- `linux/LFCS-training/failure-scenarios/scenario-2-disk-is-full.md`
- `linux/LFCS-training/failure-scenarios/scenario-3-service-is-down.md`
- `linux/LFCS-training/failure-scenarios/scenario-4-process-wont-die.md`
- `linux/LFCS-training/failure-scenarios/scenario-5-cpu-pegged.md`
- `linux/LFCS-training/failure-scenarios/scenario-6-memory-pressure.md`

Rule:

> Run these **timed** and **without hints**.

---

## ⚙️ Canonical Execution Playbooks

You must be able to select and execute:

- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`
- `linux/LFCS-training/execution-playbooks/package-repair-playbook.md`
- `linux/LFCS-training/execution-playbooks/tls-triage-playbook.md`
- `linux/LFCS-training/execution-playbooks/git-recovery-playbook.md`

Rule:

> The skill here is **choosing the right playbook first**.

---

## 🧭 Required Capabilities

You must be able to:

### Triage

- Given a vague symptom, decide:
  - is this primarily:
    - process
    - service
    - storage
    - network
    - security
    - package
    - TLS
- Prove the classification with:
  - status
  - logs
  - inspection

### Stabilize

- Stop:
  - runaway processes
  - crash loops
  - disk exhaustion
- Without:
  - destroying evidence
  - making the system less diagnosable

### Recover

- Execute the chosen playbook:
  - step by step
  - with verification
- Avoid:
  - jumping between playbooks
  - changing multiple domains at once

### Verify and Close

- Confirm:
  - original symptom is gone
  - no new failures appeared
- Explain:
  - what the root cause was
  - why the fix worked

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- Given any provided failure scenario, you can:
  - choose the correct primary playbook within a minute or two
  - execute it end-to-end without skipping steps
- You can:
  - explain the **root cause**, not just the fix
- You do not:
  - thrash between tools
  - change multiple things “just in case”

Concrete tests:

- You can:
  - recover a “system feels slow” case by identifying the true bottleneck
  - recover a “service is down” case whether the cause is config, storage, security, or package state
  - recover a “disk full” case without deleting the wrong data

---

## 🔁 Regression Rule

If later you:

- jump to fixes without diagnosis
- apply multiple playbooks at once
- cannot explain what actually failed

You must:

> Return here and re-run the failure scenarios until triage and playbook selection are automatic.

---

## 🧠 Operator Rule (Carry Forward)

> **Stabilize → Identify → Execute → Verify. Never skip a step.**

---

## 🧱 This Block Enables

- Realistic, exam-style incident handling
- Correct multi-domain reasoning
- Calm, structured recovery under pressure

Without this block, **you will know many tools but fail under integration pressure**.

---

