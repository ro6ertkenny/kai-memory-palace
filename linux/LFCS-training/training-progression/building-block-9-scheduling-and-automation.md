# 🧱 Building Block 9 — Scheduling and Automation

**Path:** `linux/LFCS-training/training-progression/building-block-9-scheduling-and-automation.md`  
**Purpose:** Build the ability to **understand, audit, and control scheduled work** so that automation helps you instead of silently breaking things.

---

## 🎯 What This Block Builds

You are building:

- The ability to:
  - determine **what runs automatically**
  - when it runs
  - under which user
- The habit of:
  - suspecting scheduled jobs when behavior is periodic
  - verifying whether automation caused or fixed a problem
- The operational skill to:
  - create safe, observable scheduled tasks
  - disable or correct harmful ones

This block turns “it keeps breaking every night” into a **traceable, controllable cause**.

---

## 🧠 Mental Models You Must Own

- Automation is:
  - just code that runs when you are not watching
- Scheduled jobs:
  - can create
  - modify
  - or destroy state
- Many “mystery” incidents are:
  - side effects of cron or timers
- A job that runs as root:
  - is as dangerous as a human root session

Invariants:

- “I can list everything that runs automatically on this system.”
- “I can explain which user runs it and why.”
- “I never assume ‘nothing is touching this’ without checking schedules.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Definition of mastery for this block:

- You can enumerate cron + timers quickly
- You can identify the triggering unit/command and the executing user
- You can verify actual runs via logs/status (not assumptions)

Rule:

> You should be able to discover, inspect, and reason about scheduled work **without guessing**.

---

## 🧪 Canonical Failure Scenarios

These are exercised after this block:

- `linux/LFCS-training/failure-scenarios/scenario-a-system-feels-slow.md` (when caused by scheduled jobs)
- Any “this happens every X minutes/hours” variant

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if a timer triggers a service)

Rule:

> When behavior is periodic, always suspect automation before blaming users or services.

---

## 🧭 Required Capabilities

You must be able to:

### Discover Scheduled Work

- For cron:
  - inspect system-wide schedules
  - inspect per-user schedules
- For systemd:
  - list timers
  - inspect what they trigger
  - see last and next run times

### Reason About Impact

- Determine:
  - what command runs
  - what it modifies
  - what user it runs as
- Predict:
  - what state it will change
  - whether it can interfere with services, storage, or users

### Control Automation Safely

- Disable:
  - a job
  - a timer
- Modify:
  - schedule frequency
  - command arguments
- Verify:
  - behavior after change
  - evidence of execution (logs/status)

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- Given a system, you can:
  - list all scheduled jobs (cron + timers)
  - identify which ones matter
- Given a recurring problem, you can:
  - prove whether automation is involved
- You can:
  - safely disable or adjust a harmful job
  - and verify the effect

Concrete tests:

- You can:
  - find a job that runs every N minutes
  - explain what it does
  - explain why it exists
- You can:
  - determine whether a spike in load or disk usage is caused by a scheduled task

---

## 🔁 Regression Rule

If later you:

- ignore automation when problems repeat on a schedule
- are surprised by background jobs changing state
- break the system with a bad scheduled task

You must:

> Return here and re-run `processes-logs-and-scheduling.md` until scheduled work is no longer invisible to you.

---

## 🧠 Operator Rule (Carry Forward)

> **If it happens on a schedule, a scheduler is involved. Find it.**

---

## 🧱 This Block Enables

- Reliable diagnosis of recurring incidents
- Safe use of automation
- Understanding of time-based side effects
- Better interpretation of logs and resource spikes

Without this block, **periodic failures will feel like ghosts**.

---

