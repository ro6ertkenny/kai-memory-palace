# 🧯 Failure Scenarios — Index (LFCS)

**Path:** `linux/LFCS-training/failure-scenarios/index.md`  
Mental mode: **Diagnosis, recovery, and proof**.  
Purpose: This directory contains **scenario-driven incident simulations** that train you to **reason under pressure**, not just type commands.

If the system is already broken and you must **figure out why and fix it**, it belongs here.

This is not a tutorial set.  
This is a **simulate → diagnose → fix → verify** training surface.

---

## 🧠 Where This Fits in the LFCS Training System

The LFCS training system has **four layers**:

1) **Building Blocks** — mental models, invariants, gates  
2) **Execution Drills** — muscle memory and command fluency  
3) **Execution Playbooks** — operator algorithms and decision flow  
4) **Failure Scenarios** — **integration + pressure testing** (this directory)

In other words:

- **Drills** teach you how to type
- **Playbooks** teach you how to think and route problems
- **Scenarios** test whether you can do both under stress

Failure scenarios are **not** about new commands.  
They are about **correct diagnosis, correct playbook choice, and clean recovery**.

---

## 🧠 How to Use This Directory

### The rule

Each scenario:

- Starts from a **symptom**
- Forces you to **gather evidence**
- Requires you to **classify the failure**
- Requires you to **choose the correct playbook**
- Then **execute a recovery**
- And finally **prove the system is healthy**

You should **not** jump to the fix.

### The workflow

1) Read the scenario
2) Reproduce or imagine the broken state
3) Inspect:
   - CPU
   - Memory
   - Disk
   - Processes
   - Services
   - Logs
4) Decide **what class of failure this is**
5) Choose the **correct execution playbook**
6) Execute recovery
7) Prove the system is fixed
8) Be able to explain **what signal led you to the correct classification**

### Study modes

- **Cold start**: Pick one scenario at random and solve it without notes
- **Timed**: Give yourself 15–20 minutes per scenario
- **Root cause training**: Focus on *why* you knew what to check first

---

## 🗂️ Scenarios in This Directory

### 1) scenario-1-system-feels-slow.md

Symptom focus:
- The machine is responsive but **everything feels sluggish**

Primary signals:
- Load average
- CPU saturation
- I/O wait
- Runaway processes

Core skills trained:
- top / htop
- ps
- load average interpretation
- Distinguishing CPU vs I/O vs memory pressure

Primary playbook:
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

Use this when:
- You want to **quickly explain why a system is slow**

---

### 2) scenario-2-disk-is-full.md

Symptom focus:
- Writes fail
- Services crash
- Logs won’t rotate
- “No space left on device”

Primary signals:
- df
- du
- Inode exhaustion
- Log growth
- Deleted-but-open files

Core skills trained:
- df, du, find
- lsof
- Log cleanup
- Emergency space recovery

Primary playbook:
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`

Use this when:
- You want to **recover a dead system caused by disk exhaustion**

---

### 3) scenario-3-service-is-down.md

Symptom focus:
- A service is not running
- A port is not listening
- A website/API is unreachable

Primary signals:
- systemctl status
- journalctl
- ss
- Exit codes and dependency failures

Core skills trained:
- systemd service control
- Log inspection
- Dependency reasoning
- Rapid restart and validation

Primary playbook:
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`

Secondary playbooks (if needed):
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`

Use this when:
- You want to **bring dead services back to life under pressure**

---

### 4) scenario-4-process-wont-die.md

Symptom focus:
- A process is stuck
- Won’t respond to SIGTERM
- Keeps respawning or won’t exit

Primary signals:
- ps
- top
- Process states
- Zombie vs uninterruptible sleep

Core skills trained:
- Signals
- kill, killall, pkill
- Understanding process states
- Knowing when a reboot is the only option

Primary playbook:
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

Use this when:
- You want to **control and reason about misbehaving processes**

---

### 5) scenario-5-cpu-pegged.md

Symptom focus:
- CPU is at or near 100%
- Fans spinning
- Everything is slow

Primary signals:
- top / htop
- Load average
- Per-process CPU usage
- Nice levels

Core skills trained:
- Identifying CPU hogs
- Renicing or killing processes
- Distinguishing real load vs blocked I/O

Primary playbook:
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

Use this when:
- You want to **quickly isolate and stop CPU runaway conditions**

---

### 6) scenario-6-memory-pressure.md

Symptom focus:
- OOM kills
- Random process deaths
- System thrashing or freezing

Primary signals:
- free
- vmstat
- dmesg
- OOM killer logs
- Swap activity

Core skills trained:
- Memory accounting
- Swap analysis
- Finding memory hogs
- Stabilizing the system

Primary playbook:
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

Secondary playbook (if disk or swap I/O is involved):
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`

Use this when:
- You want to **recover a system under memory collapse**

---

## 🧭 Relationship to Drills and Playbooks

- **Execution drills** answer:
  “What do I type to perform a task?”

- **Execution playbooks** answer:
  “What algorithm do I follow to recover this class of failure?”

- **Failure scenarios** answer:
  “Can I recognize the failure, choose the right playbook, and fix it under pressure?”

All three are required.

---

## 🎯 Completion Criteria for This Directory

You are “ready” with failure scenarios when:

- You never panic at a broken system
- You always start by **measuring, not guessing**
- You can classify the failure **before** touching anything
- You choose the correct playbook quickly
- You can recover the system and **prove it’s healthy**
- You can explain **why** your diagnostic path was correct

---

## 🧠 Core Operator Rule

> **Stabilize → Identify → Execute → Verify → Persist → Rollback if needed.**  
> **Never skip classification.**

---
