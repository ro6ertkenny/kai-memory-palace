# 🧯 Failure Scenarios — Index (LFCS)

Mental mode: **Diagnosis, recovery, and proof**.  
Purpose: This directory contains **scenario-driven incident drills** that train you to **reason under pressure**, not just type commands.

If the system is already broken and you must **figure out why and fix it**, it belongs here.

This is not a tutorial set.  
This is a **simulate → diagnose → fix → verify** training surface.

---

## 🧠 How to Use This Directory

### The rule

Each scenario:

- Starts from a **symptom**
- Forces you to **gather evidence**
- Requires you to **form a hypothesis**
- Then **apply a fix**
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
4) Decide **what is actually wrong**
5) Fix it
6) Prove it is fixed
7) Write down (mentally) what signal led you there

### Study modes

- **Cold start**: Pick one scenario at random and solve it without notes
- **Timed**: Give yourself 15–20 minutes per scenario
- **Root cause training**: Focus on *why* you knew what to check first

---

## 🗂️ Scenarios in This Directory

### A) scenario-a-system-feels-slow.md

Symptom focus:
- The machine is responsive but **everything feels sluggish**

Primary signals:
- Load average
- CPU saturation
- I/O wait
- Runaway processes

Core skills trained:
- top/htop
- ps
- load average interpretation
- Distinguishing CPU vs I/O vs memory pressure

Use this when:
- You want to **quickly explain why a system is slow**

---

### B) scenario-b-disk-is-full.md

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

Use this when:
- You want to **recover a dead system caused by disk exhaustion**

---

### C) scenario-c-service-is-down.md

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

Use this when:
- You want to **bring dead services back to life under pressure**

---

### D) scenario-d-process-wont-die.md

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

Use this when:
- You want to **control and reason about misbehaving processes**

---

### E) scenario-e-cpu-pegged.md

Symptom focus:
- CPU is at or near 100%
- Fans spinning
- Everything is slow

Primary signals:
- top/htop
- Load average
- Per-process CPU usage
- Nice levels

Core skills trained:
- Identifying CPU hogs
- Renicing or killing processes
- Distinguishing real load vs blocked I/O

Use this when:
- You want to **quickly isolate and stop CPU runaway conditions**

---

### F) scenario-f-memory-pressure.md

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

Use this when:
- You want to **recover a system under memory collapse**

---

## 🧭 Relationship to Execution Drills

Failure scenarios answer:

> “What do I do when the system is already broken?”

Execution drills answer:

> “What do I type to perform a task?”

Both are required for LFCS:

- **Execution drills** build speed and accuracy
- **Failure scenarios** build judgment and diagnosis

You should alternate between them.

---

## 🎯 Completion Criteria for This Directory

You are “ready” with failure scenarios when:

- You never panic at a broken system
- You always start by **measuring, not guessing**
- You can explain **why** you chose a diagnostic path
- You can recover the system and **prove it’s healthy**

---
