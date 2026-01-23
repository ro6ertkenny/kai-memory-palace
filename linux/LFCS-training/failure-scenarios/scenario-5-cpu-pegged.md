# 🧯 Scenario 5 — CPU Is Pegged (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-5-cpu-pegged.md`  
Mental mode: **Pressure → measure → classify → route → recover → prove**  
Primary playbook: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if the offender is service-managed)

---

## 📌 Incident Brief (Symptom-First)

The system feels hot and slow. Fans are loud.

- CPU usage is near 100%.
- Load is elevated.
- Interactivity is poor.

Your job is to:
- identify **who is burning CPU**
- decide whether it is **expected or pathological**
- choose the correct recovery route
- restore responsiveness
- prove the system is healthy

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- Name the top CPU consumer(s) with evidence
- Classify the situation as:
  - **legitimate workload**, or
  - **runaway / pathological**
- Apply the **minimal safe intervention**
- Prove:
  - CPU pressure is relieved
  - the correct process was affected
  - no new failures were introduced

---

## 🧠 Operator Rule

> **High CPU is not automatically a bug. First decide if it is doing useful work.**

---

## 🧭 Classification Buckets

You must place the incident into one bucket before acting:

1) **Legitimate heavy workload** (build, encode, scan, backup, index, etc.)
2) **Runaway loop / busy-wait bug**
3) **Process storm / fork loop**
4) **Service misbehavior**
5) **Resource interaction** (e.g., CPU pegged due to retry loops from I/O or network failures)

---

## 🧪 Required Evidence (Global Snapshot)

Capture at least one snapshot:

  uptime
  top
  # or
  htop || true

Interpretation anchors:

- `uptime`
  - Compare load average to CPU cores.
  - High load with CPUs busy (not mostly I/O wait) indicates CPU pressure.

- `top` / `htop`
  - Identify which PID(s) dominate %CPU.
  - Note user, command, and whether there are many similar processes.

---

## 🔎 Identify the Offender(s)

Record the top talkers:

  ps aux --sort=-%cpu | head -n 15

For the primary suspect:

  ps -o pid,user,stat,etime,%cpu,%mem,cmd -p PID

If it looks service-managed:

  systemctl status <unit> --no-pager || true
  journalctl -u <unit> -b --no-pager | tail -n 80 || true

---

## 🧭 Decision Forks (Evidence → Classification)

### Fork A — Legitimate heavy workload
Signals:
- process is a known task (compiler, encoder, scan, backup, index)
- user or schedule explains it
- CPU is busy but doing useful work
Route:
- No incident. Possibly throttle or reschedule if it violates SLOs.
Proof:
- you can explain **what** it is and **why** it is running

### Fork B — Runaway loop / bug
Signals:
- a single process burns CPU for a long time
- command or stack indicates tight loop or stuck retry
Route:
- `process-control-playbook.md`
Goal:
- stop or contain the offender
- capture evidence for root cause
Proof:
- CPU usage drops
- process stays stopped or fixed

### Fork C — Process storm / fork loop
Signals:
- many similar processes appear
- killing one does not reduce overall CPU
Route:
- `process-control-playbook.md`
Goal:
- stop the source (parent/service/job)
Proof:
- process count stabilizes
- CPU usage returns to normal

### Fork D — Service misbehavior
Signals:
- offender is managed by systemd
- logs show repeated errors or tight loops
Route:
- `service-recovery-playbook.md`
- then `process-control-playbook.md` if needed
Goal:
- fix root cause, then start cleanly
Proof:
- service is stable
- CPU no longer pegged

### Fork E — CPU pegged as a symptom of another failure
Signals:
- CPU burn is in retry loops
- logs indicate I/O, network, or dependency failures
Route:
- classify the **real** incident (storage, network, service)
- use the appropriate playbook
Proof:
- fixing the real cause drops CPU usage

---

## 🚫 Forbidden Actions (Diagnosis Phase)

- Do not kill a process just because it uses CPU.
- Do not confuse “busy” with “broken”.
- Do not act before you know **what** the process is and **who owns it**.

---

## 🧯 Recovery Principles

- Prefer:
  - stopping or throttling at the **source** (service, job, scheduler)
- Escalate signals:
  - graceful stop → verify → force only if necessary
- If it’s legitimate work:
  - the “fix” may be scheduling or capacity, not killing

---

## ✅ Verification (Required Proof)

After intervention:

  uptime
  ps aux --sort=-%cpu | head -n 10

If a service was involved:

  systemctl status <unit> --no-pager
  systemctl --failed
  journalctl -u <unit> -b --no-pager | tail -n 50 || true

Define “healthy” as:
- CPU usage trending down to normal
- no runaway offender
- no new service failures

---

## 🧾 Post-Incident Debrief

Answer:

- Which process(es) were using CPU?
- Was it legitimate or pathological?
- Which failure bucket was this?
- What was the minimal safe action?
- What prevents recurrence?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Killing “the top process” without understanding it
- Treating all high CPU as a bug
- Ignoring process storms and only killing one PID
- Fixing symptoms without identifying the real cause

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** recovery and verification.

Do **not** use this section while solving the incident.

### If you hesitated identifying the real offender or process class:
- Drill:
  - `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-4-process-model.md`

### If this was a service-driven loop:
- Drill:
  - `linux/LFCS-training/execution-drills/services-and-logging.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-6-services-and-systemd.md`

### If CPU was pegged due to another resource failure:
- Drill:
  - `linux/LFCS-training/execution-drills/storage-and-mounts.md`
  - `linux/LFCS-training/execution-drills/networking.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

Purpose of this section:
- improve classification accuracy
- avoid “kill-first” reflexes
- strengthen root-cause thinking

---
