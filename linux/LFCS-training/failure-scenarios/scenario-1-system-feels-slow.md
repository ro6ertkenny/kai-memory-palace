# 🧯 Scenario 1 — The System Feels Slow (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-1-system-feels-slow.md`  
Mental mode: **Pressure → measure → classify → route → recover → prove**  
Primary playbook: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md` (if disk/inodes/log pressure is causal)
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if the offender is a managed service)

---

## 📌 Incident Brief (Symptom-First)

A user reports:

> “Everything is laggy.”

No other context is provided.

Your job is to:
- classify the dominant failure axis
- identify the likely offender class
- choose the correct playbook route
- restore responsiveness
- prove the system is healthy

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- State the primary axis:
  - CPU saturation
  - memory pressure / thrash
  - disk / inode / I/O wait
  - runaway process (or process storm)
- Name the top offender process or subsystem with evidence
- Execute the smallest safe recovery
- Prove the system is stable (not just “feels better”)

---

## 🧠 Operator Rule

> **Measure first. Classify second. Act last.**  
> **Global signals before local causes.**

---

## 🧭 Classification Buckets

You must place the incident into one bucket before acting:

1) **CPU saturation**
2) **I/O wait / storage bottleneck**
3) **Memory pressure / swap thrash / OOM risk**
4) **Process storm / runaway job**
5) **Disk or inode exhaustion (secondary cause of “slow”)**
6) **Service-level degradation (managed unit, queue buildup, repeated restarts)**

---

## 🧪 Required Evidence (Global Snapshot)

Capture at least one global snapshot before touching anything.

  uptime
  free -h
  df -h
  df -i
  vmstat 1 5
  iostat -xz 1 3 || true

Interpretation anchors:

- `uptime`
  - Compare load average to CPU cores.
  - Load >> cores can mean runnable CPU pressure or blocked I/O.

- `free -h`
  - Prefer “available” over “free”.
  - Very low “available” with rising swap activity implies pressure.

- `df -h` / `df -i`
  - Near-100% usage or inode exhaustion can create systemic slowness.

- `vmstat`
  - High `wa` suggests I/O wait.
  - High `si/so` suggests swap in/out thrash.

- `iostat` (if available)
  - High util / await indicates storage contention.

---

## 🔎 Identify the Offender Class (Top Talkers)

Find the largest consumers first (do not act yet):

  ps aux --sort=-%cpu | head -n 15
  ps aux --sort=-%mem | head -n 15

Then confirm with interactive view:

  top
  # or
  htop || true

Record:
- PID
- user
- %CPU / %MEM
- elapsed time
- command
- whether it is a service-managed process

If the suspected offender is a service:

  systemctl status <unit> --no-pager || true
  journalctl -u <unit> -b --no-pager | tail -n 80 || true

---

## 🧭 Decision Forks (Evidence → Classification)

### Fork A — CPU saturation
Signals:
- one or a few processes dominate CPU
- load is high and CPU is busy (not mostly I/O wait)
Route:
- `process-control-playbook.md`
Goal:
- stabilize by lowering impact (priority/throttle/stop/kill as justified)
Proof:
- load drops
- system responsiveness returns
- root cause is understood (what started it)

### Fork B — I/O wait / storage bottleneck
Signals:
- `vmstat` shows high `wa`
- load high but CPUs are mostly waiting
- storage latency/util high (if iostat available)
Route:
- `storage-recovery-playbook.md` (if capacity/log pressure)
- `process-control-playbook.md` (if a process is generating I/O storm)
Proof:
- I/O wait decreases
- disk usage/inodes under control
- offending writer identified (if applicable)

### Fork C — Memory pressure / swap thrash
Signals:
- low “available” memory
- swap activity increases (`si/so`)
- OOM warnings or instability in logs
Route:
- `process-control-playbook.md`
Proof:
- swap thrash stops
- memory headroom returns
- system stabilizes without recurring OOM

### Fork D — Disk/inode exhaustion masquerading as “slow”
Signals:
- `df -h` or `df -i` near 100%
- logs failing, services degraded, shell lag
Route:
- `storage-recovery-playbook.md`
Proof:
- headroom restored
- services stop erroring due to storage constraints

### Fork E — Process storm / runaway job
Signals:
- many similar processes spawn
- load increases due to process count churn
- cron/systemd timer loop or fork bomb pattern (rare but trainable)
Route:
- `process-control-playbook.md`
Secondary:
- `service-recovery-playbook.md` if systemd unit respawns
Proof:
- process count stabilizes
- source of storm identified and stopped

---

## 🚫 Forbidden Actions (Diagnosis Phase)

Until you have classified the bucket and captured at least one snapshot:

- Do not kill processes
- Do not restart services
- Do not delete files
- Do not reboot

---

## ✅ Verification (Required Proof)

After recovery actions, prove health:

  uptime
  free -h
  vmstat 1 3
  ps aux --sort=-%cpu | head -n 10

If a service was involved:

  systemctl --failed
  systemctl status <unit> --no-pager || true
  journalctl -u <unit> -b --no-pager | tail -n 50 || true

Define “healthy” as:
- load trending down or appropriate for workload
- no uncontrolled swap thrash
- no storage hard limits
- no runaway top offender

---

## 🧾 Post-Incident Debrief

Answer:

- What was the first reliable signal?
- What failure bucket did you classify?
- Which playbook did you choose and why?
- What was the minimal safe recovery?
- What evidence proves the system is healthy?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Acting before measurement
- Treating “slow” as automatically “CPU”
- Killing the top process without understanding ownership/role
- Ignoring `wa` and swapping signals
- Fixing symptoms (restart) without identifying the cause class

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** recovery and verification.

Do **not** use this section while solving the incident.

### If you misread load / CPU vs I/O wait
- Drill:
  - `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
  - `linux/LFCS-training/execution-drills/files-and-text.md` (for log slicing under pressure)
- Building block:
  - `linux/LFCS-training/training-progression/building-block-4-process-model.md`

### If you hesitated on resource measurement and interpretation
- Drill:
  - `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

### If the root cause was storage pressure or I/O contention
- Drill:
  - `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-10-storage-fundamentals.md`

Purpose of this section:
- close the exact skill gap revealed by the incident
- strengthen classification accuracy under time pressure

---
