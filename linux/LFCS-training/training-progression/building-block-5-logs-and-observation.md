# 🧱 Building Block 5 — Logs and Observation

**Path:** `linux/LFCS-training/training-progression/building-block-5-logs-and-observation.md`  
**Purpose:** Build the habit of **observing before acting** and the skill to **use logs as the primary truth source** for system behavior.

---

## 🎯 What This Block Builds

You are building:

- The reflex to:
  - check status
  - read logs
  - correlate timestamps
- The ability to:
  - distinguish symptoms from causes
  - identify the first real error
  - avoid “fixing” the wrong problem

This block turns “it doesn’t work” into a **traceable, time-ordered explanation**.

---

## 🧠 Mental Models You Must Own

- The system already explains itself:
  - you just have to **look in the right place**
- Logs are:
  - append-only evidence
  - ordered in time
  - more reliable than guesses or assumptions
- Most failures are:
  - preceded by warnings
  - accompanied by explicit errors
- The first meaningful error is usually:
  - the cause
  - not the last cascade of symptoms

Invariants:

- “I do not change anything until I have read the relevant logs.”
- “I can explain what happened, in what order, and why.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Rule:

> You should be able to find the right log source and extract the relevant lines **without hesitation**.

---

## 🧪 Canonical Failure Scenarios

These are exercised after this block:

- `linux/LFCS-training/failure-scenarios/scenario-c-service-is-down.md`
- `linux/LFCS-training/failure-scenarios/scenario-a-system-feels-slow.md`

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

Rule:

> You should never execute a recovery playbook without first checking status and logs.

---

## 🧭 Required Capabilities

You must be able to:

### Find the Right Evidence

- For a service:
  - check its supervisor status
  - locate its journal entries
- For a system issue:
  - inspect general system logs
  - correlate with the time the problem started

### Read Logs Effectively

- Filter:
  - by service
  - by time window
  - by severity or keyword
- Identify:
  - the first real error
  - configuration parse errors
  - permission denials
  - crash loops

### Correlate Time

- Answer:
  - what happened first
  - what happened after
  - what changed right before the failure

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- Given a failing service, you can:
  - find its relevant logs
  - identify the specific error
  - explain why it failed
- Given a system complaint (“slow”, “broken”, “down”), you can:
  - find evidence in logs
  - correlate events by time
  - distinguish cause from effect
- You do not:
  - change configs first
  - restart things blindly
  - “try fixes” before reading logs

Concrete tests:

- You can:
  - explain a service failure using only status + logs
  - find the exact line that explains the failure
- You can:
  - answer “what changed?” using timestamps and log order

---

## 🔁 Regression Rule

If later you:

- restart things without checking logs
- change configs without understanding the error
- chase symptoms instead of causes

You must:

> Return here and re-run `services-and-logging.md` until observation is automatic.

---

## 🧠 Operator Rule (Carry Forward)

> **Logs are the first source of truth. Look before you touch.**

---

## 🧱 This Block Enables

- Safe service recovery
- Correct security triage
- Accurate process diagnosis
- Almost every meaningful troubleshooting workflow

Without this block, **you are operating blind**.

