# 🧯 Scenario 6 — Memory Pressure (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-6-memory-pressure.md`  
Mental mode: **Pressure → measure → classify → route → recover → prove**  
Primary playbook: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md` (if swap or disk I/O is part of the collapse)
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if a service is the offender)

---

## 📌 Incident Brief (Symptom-First)

The system is:

- slow
- laggy
- intermittently timing out
- sometimes killing processes

Nothing is obviously “crashed”.

You are told:

> “We think it’s a memory problem.”

Your job is to:
- **prove or disprove** that claim using evidence
- classify the **type of memory failure**
- identify the **real consumers**
- stabilize the system
- prove it is healthy

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- State whether **real memory pressure exists**
- Classify the incident as:
  - global memory pressure
  - cgroup / container limit pressure
  - or “not a memory problem”
- Identify the **top real consumers (RSS)**
- Apply the **minimal safe intervention**
- Prove:
  - pressure signals are gone
  - the system is stable
  - OOM or thrash is not recurring

---

## 🧠 Operator Rule

> **Never decide based on “used memory”.**  
> Decide based on **pressure signals and reclaim activity**.

---

## 🧭 Classification Buckets

You must place the incident into one bucket before acting:

1) **No real memory pressure** (symptom is elsewhere)
2) **Global memory pressure with swap thrash**
3) **Global memory pressure leading to OOM**
4) **Cgroup / container memory limit pressure**
5) **Runaway process or memory leak**
6) **Memory pressure as a secondary effect** (e.g., disk or I/O collapse)

---

## 🧪 Required Evidence (Global Snapshot)

Capture at least one snapshot:

  free -h
  vmstat 1 5
  cat /proc/pressure/memory

Interpretation anchors:

- `free -h`
  - Look at **MemAvailable**, not MemFree.

- `vmstat`
  - `si/so` > 0 means active swap thrash.
  - sustained non-zero = real pressure.

- `/proc/pressure/memory`
  - non-zero `some` or `full` averages = tasks are stalling due to memory.

Decision gate:

- If **si/so = 0** and **PSI = 0** → this is **not a memory incident**.
- If **si/so > 0** or **PSI > 0** → real memory pressure exists.

---

## 🧩 Check for Scoped (cgroup) Pressure

If this is a containerized or limited environment:

  cat /sys/fs/cgroup/memory.pressure || true
  cat /sys/fs/cgroup/memory.events || true
  cat /sys/fs/cgroup/memory.current || true
  cat /sys/fs/cgroup/memory.max || true

Interpretation anchors:

- `memory.events` shows `max` or `oom_kill` → limit was hit.
- `memory.pressure` non-zero → scoped pressure even if host is fine.

Meaning:

- You can have **severe memory pressure inside a cgroup** even if the machine has free RAM.

---

## 🔎 Identify the Real Consumers

List top RSS users:

  ps aux --sort=-%mem | head -n 15

For a suspect:

  cat /proc/<PID>/status | egrep -i "VmRSS|RssAnon|RssFile|VmSwap"

Interpretation anchors:

- `VmRSS` = real RAM usage
- `VmSwap` > 0 = this process is being swapped
- VSZ / VmSize are **not** real memory usage

If service-managed:

  systemctl status <unit> --no-pager || true
  journalctl -u <unit> -b --no-pager | tail -n 80 || true

---

## 🧭 Decision Forks (Evidence → Classification)

### Fork A — Not a memory problem
Signals:
- MemAvailable healthy
- si/so = 0
- PSI = 0
Route:
- This is CPU, I/O, or service degradation → exit to correct scenario/playbook.
Proof:
- memory signals show no pressure

### Fork B — Global memory pressure with thrash
Signals:
- si/so > 0
- PSI non-zero
- system sluggish but alive
Route:
- `process-control-playbook.md`
Goal:
- reduce load or stop offender
- restore headroom
Proof:
- si/so returns to 0
- PSI decays to 0
- system stabilizes

### Fork C — OOM events
Signals:
- dmesg / logs show OOM kills
- processes dying
Route:
- `process-control-playbook.md`
Goal:
- stop the offender
- prevent recurrence
Proof:
- no further OOM kills
- memory headroom restored

### Fork D — Cgroup / container limit
Signals:
- memory.events shows `max` or `oom_kill`
- host may look healthy
Route:
- `process-control-playbook.md` or service-specific fix
Goal:
- fix leak or raise limit intentionally
Proof:
- pressure stops inside the cgroup

### Fork E — Memory pressure as secondary effect
Signals:
- pressure appears after disk, I/O, or service failures
Route:
- classify and fix the **real** incident
Proof:
- fixing root cause clears memory pressure

---

## 🚫 Forbidden Actions (Diagnosis Phase)

- Do not decide based on “used memory”.
- Do not reboot before classification.
- Do not kill processes before identifying the real consumers.
- Do not treat cache usage as a problem.

---

## 🧯 Recovery Principles

- Always remove **pressure**, not just symptoms.
- Prefer:
  - stopping or fixing the offender
  - not just adding swap or rebooting
- If it’s scoped:
  - fix the **limit or the app**, not the host

---

## ✅ Verification (Required Proof)

After intervention:

  free -h
  vmstat 1 5
  cat /proc/pressure/memory

You want:

- `si/so` back to 0
- PSI averages trending to 0
- MemAvailable stable
- No new OOM events

Optional:

  dmesg -T | tail -n 100

---

## 🧾 Post-Incident Debrief

Answer:

- Did real memory pressure exist?
- Was it global or scoped?
- Which process or service caused it?
- Which failure bucket was this?
- What was the minimal safe fix?
- What prevents recurrence?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Deciding from “used memory”
- Ignoring PSI and swap signals
- Killing random processes
- Adding swap to hide a leak
- Rebooting without understanding cause

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** recovery and verification.

Do **not** use this section while solving the incident.

### If you misread memory signals:
- Drill:
  - `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

### If the root cause was a runaway process or leak:
- Drill:
  - `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-4-process-model.md`

### If this was a cgroup / container limit issue:
- Drill:
  - `linux/LFCS-training/execution-drills/containers-and-virtualization.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

Purpose of this section:
- improve pressure-signal interpretation
- prevent “guessing” memory incidents
- strengthen root-cause discipline

---
