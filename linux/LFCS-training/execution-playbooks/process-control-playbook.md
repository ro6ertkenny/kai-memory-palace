# ⚙️ Process Control Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/process-control-playbook.md`  
Mental mode: **Measure → Classify → Stabilize → Fix Source → Verify → Prevent**  
Purpose: Stabilize a system by diagnosing and controlling **runaway, stuck, or pathological processes** using a **safe, exam-grade operator algorithm**.

This is **not** a tutorial.  
This is a **live-system decision and action playbook**.

---

## 🧠 When To Use This Playbook

Use this playbook when the **primary symptom** is:

- CPU is pegged
- Memory pressure or OOM risk
- A process won’t die or appears stuck
- The system feels slow due to process behavior
- Too many processes / fork-like behavior
- Zombie processes observed

Do **not** use this playbook if the **first evidence** points to:

- disk, mount, or I/O blockage → `storage-recovery-playbook.md`
- a service lifecycle failure → `service-recovery-playbook.md`
- network or DNS → `network-diagnosis-playbook.md`
- SELinux or policy → `security-triage-playbook.md`

---

## 🧭 Scenarios That Validate This Playbook

This playbook is exercised by:

- `linux/LFCS-training/failure-scenarios/scenario-1-system-feels-slow.md`
- `linux/LFCS-training/failure-scenarios/scenario-4-process-wont-die.md`
- `linux/LFCS-training/failure-scenarios/scenario-5-cpu-pegged.md`
- `linux/LFCS-training/failure-scenarios/scenario-6-memory-pressure.md`

If you cannot solve those scenarios **cleanly and repeatably**, this playbook is not yet fluent.

---

## 🧪 Drills Required For Fluency

You should be mechanically fluent with:

- `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`
- `linux/LFCS-training/execution-drills/storage-and-mounts.md` (for D-state and I/O wait cases)

This playbook is a **composition layer**, not a source of primitives.

---

## 🧠 Operator Contract

Always proceed in this order:

1. Measure
2. Identify the offender
3. Inspect
4. Classify
5. Stabilize (minimum safe action)
6. Fix root cause
7. Verify
8. Make persistent (if required)
9. Roll back if needed

> **Never start by killing random PIDs.**

---

## 🧭 Global Safety Rules

- Preserve evidence first.
- If a PID is systemd-managed, prefer `systemctl` over signals.
- If a suspect process is in `D` state, **stop using signals** and switch to storage/I/O diagnosis.
- Prefer smallest safe action: renice → TERM → KILL.
- Every action requires verification.

---

## 🧭 Classification Buckets (Pick One Before Acting)

You must place the incident into **exactly one** bucket:

1) Single runaway process  
2) Process storm / fork loop  
3) Service-managed respawn loop  
4) Uninterruptible sleep (D-state) / blocked I/O  
5) Zombie accumulation  
6) Memory pressure driven by a process  
7) Not actually a process problem (exit this playbook)

---

## 🧪 Phase 1 — Global Triage (Always First)

Capture at least one snapshot:

  uptime  
  free -h  
  top || true  
  vmstat 1 5 || true  

Quick offender scan:

  ps aux --sort=-%cpu | head -n 15  
  ps aux --sort=-%mem | head -n 15  

Interpretation gates:

- If `wa` is high or processes are in D-state → exit to `storage-recovery-playbook.md`
- If `si/so` or PSI indicates memory pressure → memory-driven path
- If one or many processes dominate CPU → process path
- If this does not look process-shaped → exit this playbook

---

## 🧪 Phase 2 — Identify the Offender Class

Record for suspects:

- PID
- user
- %CPU / %MEM
- elapsed time
- command
- whether it is service-managed

If many similar processes appear → suspect **storm** or **respawn loop**.

---

## 🧩 Phase 3 — Inspect a Specific Process

For a candidate PID:

  ps -o pid,ppid,stat,etime,%cpu,%mem,cmd -p PID  

Interpret `STAT`:

- R / S → normal userspace (killable)
- Z → zombie (already dead, parent problem)
- D → uninterruptible sleep (kernel I/O wait, not killable)
- T → stopped

Decision gate:

- Z → fix the **parent**
- D → fix **I/O or kernel condition** (exit playbook)
- R/S/T → you may act on the process

---

## 🧭 Phase 4 — Route Selection

### Route A — Single runaway process
- One PID dominates CPU or memory
- Not a service, or clearly misbehaving

### Route B — Process storm / fork loop
- Many similar PIDs
- Killing one does not reduce the count

### Route C — Service-managed respawn
- PID returns immediately
- systemd restart policy involved  
→ Exit to `service-recovery-playbook.md`

### Route D — D-state / blocked I/O  
→ Exit to `storage-recovery-playbook.md`

### Route E — Zombies
- Many Z processes  
→ Fix or restart the parent

### Route F — Memory pressure driven by a process
- Swap, PSI, OOM risk  
→ Contain top RSS offender first

---

## 🗡️ Phase 5 — Controlled Intervention

Escalation ladder (for killable processes):

1) Graceful:

  kill PID  

2) Verify:

  ps -p PID || echo "gone"  

3) Force:

  kill -9 PID  

4) Verify again:

  ps -p PID || echo "gone"  

Rules:

- Never spam `kill -9`
- Never kill multiple things at once
- Always observe system impact after each step

If the process is service-managed:

- Stop the service, not the PID
- Then fix the service

---

## 🧯 Phase 6 — Stabilize and Prove

After intervention:

  uptime  
  top || true  
  ps aux --sort=-%cpu | head -n 10  
  free -h  
  vmstat 1 3  

If a service was involved:

  systemctl --failed --no-pager  
  systemctl status <unit> --no-pager  

Define “stable” as:

- load trending to normal
- no storm or respawn loop
- no swap thrash
- no growing D-state backlog

---

## 🧾 Phase 7 — Root Cause Capture

You must be able to answer:

- What started the offender?
- Why did it run this long or spawn this much?
- Why was it not bounded or supervised?
- What change prevents recurrence?

If you cannot answer these, the incident is **not finished**.

---

## 🔁 Rollback Strategy

If you stopped or reniced the wrong thing:

- Restart service:

  systemctl start <service>  

- Reset nice value:

  renice 0 -p <pid>  

Re-check:

  uptime  
  systemctl status <service> --no-pager  

---

## 🚫 Anti-Patterns (Auto-Fail)

- Killing the “top” process without understanding it
- Treating symptoms (PIDs) instead of sources (services, jobs)
- Ignoring D-state and blaming the process
- Rebooting without classification
- Declaring victory because “CPU dropped”

---

## 🧭 Exit Conditions

Exit immediately if you discover:

- disk or mount is the real blocker → `storage-recovery-playbook.md`
- service lifecycle is broken → `service-recovery-playbook.md`
- policy/SELinux is blocking → `security-triage-playbook.md`
- network or DNS is causal → `network-diagnosis-playbook.md`

---

## ✅ Completion Criteria

- System is stable
- Offender is gone or controlled
- Source is fixed or disabled
- Services are in intended states
- You can explain:
  - what failed
  - why it failed
  - why your fix was safe
  - how you verified recovery

---

## 🧠 Operator Loop (Reinforced)

Symptom → Measure → Classify → Contain → Fix Source → Verify → Prevent

Never skip classification.

---
