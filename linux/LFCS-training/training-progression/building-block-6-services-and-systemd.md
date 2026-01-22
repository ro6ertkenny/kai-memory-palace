# 🧱 Building Block 6 — Services and systemd

**Path:** `linux/LFCS-training/training-progression/building-block-6-services-and-systemd.md`  
**Purpose:** Build the operational ability to **control, inspect, and recover services** using systemd, with verification and safe state transitions.

---

## 🎯 What This Block Builds

You are building:

- A precise understanding of:
  - what a service is (a supervised process)
  - what systemd actually does (start, stop, monitor, restart)
- The ability to:
  - inspect service state
  - interpret failure modes
  - perform **safe lifecycle operations** (start/stop/restart/enable/disable)
  - recover a failed service using evidence (status + logs)

This block turns “the service is down” into a **repeatable operator procedure**.

---

## 🧠 Mental Models You Must Own

- A service is:
  - a process
  - plus a supervisor
  - plus a policy (restart, dependencies, ordering)
- systemd is:
  - the authority on service state
  - the first place to ask “what is wrong?”
- Restarting is not a fix:
  - it is a **test**
- Enable/disable affects:
  - boot-time behavior
  - not current runtime state

Invariants:

- “I always ask systemd for the truth first.”
- “I never assume a restart fixed anything until I verify.”
- “I can explain why a service failed before I touch config.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Rule:

> You should be able to inspect, start, stop, restart, enable, disable, and query services **without hesitation**.

---

## 🧪 Canonical Failure Scenarios

These are exercised after this block:

- `linux/LFCS-training/failure-scenarios/scenario-c-service-is-down.md`

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`

Rule:

> You should be able to follow this playbook without being surprised by systemd behavior.

---

## 🧭 Required Capabilities

You must be able to:

### Inspect Service State

- Determine:
  - active/inactive/failed
  - exit codes
  - restart behavior
  - recent failures
- Identify:
  - the main PID
  - the unit file in use
  - recent log entries for the unit

### Control Service Lifecycle

- Perform:
  - start
  - stop
  - restart
  - reload (when applicable)
- Control boot behavior:
  - enable
  - disable
- Understand:
  - runtime state vs boot-time state

### Reason About Dependencies

- Recognize:
  - a service that fails because a dependency is missing
  - ordering problems
- Use status output to:
  - see which dependency blocked startup

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- Given a service name, you can:
  - determine its state
  - find its logs
  - explain why it is running or not running
- Given a failed service, you can:
  - attempt a controlled restart
  - verify whether it truly recovered
- You understand and can explain:
  - the difference between `start/stop` and `enable/disable`

Concrete tests:

- You can:
  - recover a stopped service using only status + logs
  - explain a failure using systemd output
- You never:
  - repeatedly restart without checking logs
  - assume “active” means “healthy” without verification

---

## 🔁 Regression Rule

If later you:

- restart services blindly
- ignore systemd status output
- confuse enable/disable with start/stop

You must:

> Return here and re-run `services-and-logging.md` until service lifecycle control is automatic.

---

## 🧠 Operator Rule (Carry Forward)

> **systemd is the authority on service truth. Ask it first.**

---

## 🧱 This Block Enables

- Reliable service recovery
- Correct log-based diagnosis
- Safe configuration changes (next block)
- All higher-level incident response involving services

Without this block, **service operations become trial-and-error**.

---
