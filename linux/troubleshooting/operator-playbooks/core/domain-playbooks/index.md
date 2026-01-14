# 🧱 Domain Playbooks — Operator Physics Index

This directory contains the **canonical pressure / failure domain playbooks** for Linux operators.

These are **not scenarios**.  
These are the **physics of failure**.

If you can correctly identify the **domain**, the solution space collapses.

---

## 🧠 Mental Model

- **Domain playbooks = physics**
  - What class of failure is happening?
  - What resource or system is under pressure?
  - What kind of failure mode is this?

- **Scenario playbooks = symptoms**
  - How the failure presents
  - What the user or system reports
  - What the alert says

Every real incident reduces to **one of these domains**.

---

## 📚 How To Use This Index

1. Start from the **symptom**
2. Map it to a **domain**
3. Use the **domain playbook** to:
   - Triage
   - Differentiate
   - Stabilize
   - Decide escalation

Do not start with tools.  
Start with **classification**.

---

## ✅ Canonical Domain Set

These seven playbooks intentionally cover ~95% of real Linux production incidents.

---

### 🧠 Memory Pressure

**File:** `memory-pressure-playbook.md`

Use this when you see:
- “System is slow”
- “Things freeze under load”
- “Container OOMs”
- “Random stalls”
- Swap activity, reclaim, or OOMs

This domain explains:
- MemAvailable
- Reclaim
- Swap
- OOM
- cgroups memory
- PSI memory

---

### 🧮 CPU Pressure

**File:** `cpu-pressure-playbook.md`

Use this when you see:
- “CPU pegged”
- “System feels laggy”
- “Everything is slow but memory is fine”
- High load, high run queue

This domain explains:
- Scheduler saturation
- Run queue vs cores
- PSI CPU
- Throttling
- Steal time

---

### 💽 IO Pressure

**File:** `io-pressure-playbook.md`

Use this when you see:
- “System frozen”
- “Commands hang”
- “Process won’t die”
- High load with low CPU
- `D` state processes

This domain explains:
- Storage latency
- Queue depth
- iowait
- PSI IO
- Journal and fsync stalls

---

### 🧱 Disk Exhaustion

**File:** `disk-exhaustion-playbook.md`

Use this when you see:
- “No space left on device”
- “But df shows space”
- “Deleting files didn’t help”
- Filesystem went read-only

This domain explains:
- Block exhaustion
- Inode exhaustion
- Deleted-but-open files
- Filesystem allocation semantics

---

### 🔁 Process & Service Failures

**File:** `process-and-service-failures-playbook.md`

Use this when you see:
- “Service keeps restarting”
- “Process won’t die”
- “Why did it come back?”
- Crash loops
- Zombie processes

This domain explains:
- Process ownership
- Supervision and control loops
- systemd behavior
- Zombies and orphans

---

### 🌐 Network & DNS Failures

**File:** `network-and-dns-failures-playbook.md`

Use this when you see:
- “Sometimes it works”
- “Only from some nodes”
- “It times out but nothing is down”
- “Works with IP but not hostname”

This domain explains:
- DNS resolution
- Routing
- Packet delivery
- Partial connectivity failures

---

### ⏱️ Time & Clock Failures

**File:** `time-and-clock-failures-playbook.md`

Use this when you see:
- TLS cert “not yet valid” or “expired”
- Auth tokens always rejected
- Works on one node but not another
- Logs out of order
- Things broke after reboot

This domain explains:
- Clock skew
- NTP / chrony
- Time as trust
- Distributed systems time dependence

---

## 🧭 Classification First, Tools Second

Always ask:

> “Which **domain** is this?”

Not:

> “Which command should I run?”

Correct classification makes the incident **mechanical**.

---

## 🧱 Design Rule

We intentionally do **not** add:

- One playbook per tool
- One playbook per distro quirk
- One playbook per random symptom

Those belong in:

> `core/scenario-playbooks/`

This set stays **small, stable, and fundamental**.

---

## 🏁 Canonical Set Summary

- 5 mandatory:
  - Memory
  - CPU
  - IO
  - Disk
  - Process/Service

- 2 optional but high-value:
  - Network/DNS
  - Time/Clock

Total:

> **7 domain playbooks = the operator physics of Linux**

---
