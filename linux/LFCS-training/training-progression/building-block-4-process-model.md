# 🧱 Building Block 4 — Process Model

**Path:** `linux/LFCS-training/training-progression/building-block-4-process-model.md`  
**Purpose:** Build a **correct mental model of processes** and the operational ability to **observe, classify, and control running programs safely**.

---

## 🎯 What This Block Builds

You are building:

- A precise understanding of:
  - what a process is
  - how processes relate (parent/child)
  - what “state” means (running, sleeping, zombie, etc.)
- The ability to:
  - identify what is actually consuming resources
  - decide whether a process is healthy or pathological
  - intervene **without destabilizing the system**

This block turns “the system feels slow” from a vague complaint into a **mechanical diagnosis**.

---

## 🧠 Mental Models You Must Own

- A process is:
  - a running instance of a program
  - with identity (PID, owner), state, and resources
- Services are:
  - just processes supervised by a manager
- Not all “busy” processes are broken:
  - some workloads are legitimately CPU or I/O heavy
- Process states matter:
  - `R` running
  - `S` sleeping
  - `D` uninterruptible sleep (usually I/O)
  - `Z` zombie (already dead; parent problem)
- Killing a process is:
  - an operational decision
  - not a reflex

Invariants:

- “I can explain what this process is and why it exists.”
- “I know whether high usage is expected or pathological.”
- “I never kill something before I understand its role.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Rule:

> You should be able to identify, sort, filter, and inspect processes **without hesitation**.

---

## 🧪 Canonical Failure Scenarios

These are exercised after this block:

- `linux/LFCS-training/failure-scenarios/scenario-1-system-feels-slow.md`
- `linux/LFCS-training/failure-scenarios/scenario-4-process-wont-die.md`
- `linux/LFCS-training/failure-scenarios/scenario-5-cpu-pegged.md`
- `linux/LFCS-training/failure-scenarios/scenario-6-memory-pressure.md`

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

Rule:

> You should be able to execute this playbook without being confused by process states or relationships.

---

## 🧭 Required Capabilities

You must be able to:

### Observe the System

- Determine:
  - load vs actual CPU usage
  - memory pressure vs free memory
- Identify:
  - top CPU consumers
  - top memory consumers
  - unusual process counts

### Inspect a Process

- For any PID, determine:
  - owner
  - runtime
  - command line
  - state
  - parent

### Classify Behavior

- Decide whether a process is:
  - a legitimate workload
  - misbehaving
  - stuck
  - already dead (zombie)
  - blocked on I/O

### Control Processes Safely

- Use:
  - priority adjustment
  - graceful termination
  - forced termination
- Understand:
  - why `KILL` may not work in `D` state
  - why zombies require fixing the parent, not the child

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- Given a “slow system”, you can:
  - identify the real resource bottleneck
  - name the offending process(es)
- Given any PID, you can:
  - explain what it is
  - explain why it exists
  - explain whether it should be there
- You can:
  - stabilize a system by controlling processes
  - without killing critical services blindly

Concrete tests:

- You can explain the difference between:
  - CPU-bound vs I/O-bound slowness
  - a zombie vs a stuck process
- You can handle:
  - a runaway process
  - a process that ignores TERM
  - a system under memory pressure

---

## 🔁 Regression Rule

If later you:

- kill the wrong process
- misdiagnose “slow” as CPU when it’s I/O or memory
- panic-kill without understanding the role of a process

You must:

> Return here and re-run `processes-logs-and-scheduling.md` until classification and control are automatic.

---

## 🧠 Operator Rule (Carry Forward)

> **Never kill a process until you can explain what it is and who started it.**

---

## 🧱 This Block Enables

- Safe system stabilization
- Correct service recovery
- Meaningful log analysis
- All performance and resource triage

Without this block, **incident response becomes guesswork**.

---
