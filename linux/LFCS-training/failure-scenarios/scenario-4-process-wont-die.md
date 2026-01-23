# 🧯 Scenario 4 — A Process Won’t Die (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-4-process-wont-die.md`  
Mental mode: **Pressure → measure → classify → route → recover → prove**  
Primary playbook: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md` (if blocked I/O is causal)
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if the process is service-managed)

---

## 📌 Incident Brief (Symptom-First)

You try to stop a process:

  kill PID

The process is **still there**.

Even:

  kill -9 PID

…does not remove it.

Your job is to:
- classify **what kind of “unkillable” this is**
- identify the **real root cause**
- choose the correct recovery route
- restore system sanity
- prove the system is healthy

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- State **which process state** you are dealing with
- Explain **why signals do or do not work**
- Identify the **real blocking cause** (not just the symptom)
- Apply the **correct fix path**
- Prove:
  - the system is no longer wedged
  - the process situation is stable
  - no collateral damage was introduced

---

## 🧠 Operator Rule

> **SIGKILL is not magic. The kernel always wins.**  
> **You cannot kill what is not in userspace.**

---

## 🧭 Classification Buckets

You must place the incident into one bucket before acting:

1) **Normal process ignoring or slow to handle SIGTERM**
2) **Zombie process (already dead, waiting for parent)**
3) **Uninterruptible sleep (D-state) blocked in kernel I/O**
4) **Service-managed respawn loop**
5) **Process storm or fork loop**
6) **Kernel or driver hang (rare but catastrophic)**

---

## 🧪 Required Evidence (Process State)

Capture at least one snapshot:

  ps -o pid,ppid,stat,etime,cmd -p PID

Interpretation anchors for `STAT`:

- R = running
- S = sleeping
- T = stopped
- Z = zombie (already dead)
- D = uninterruptible sleep (blocked in kernel I/O)

---

## 🧭 Decision Forks (Evidence → Classification)

### Fork A — Normal process ignoring SIGTERM
Signals:
- STAT is R or S
- process disappears after SIGKILL
Route:
- `process-control-playbook.md`
Goal:
- understand why it hung
- stop it cleanly or contain it
Proof:
- process stays gone
- system load / behavior normalizes

### Fork B — Zombie process (Z)
Signals:
- STAT shows Z
- PID persists but uses no resources
Meaning:
- the process is already dead
- only the **parent** can reap it
Route:
- `process-control-playbook.md`
Action:
- identify the parent (PPID)
- fix or restart the parent
Proof:
- zombie disappears
- parent behaves correctly

### Fork C — Uninterruptible sleep (D-state)
Signals:
- STAT contains D
- process does not die even with SIGKILL
Meaning:
- the process is blocked in kernel space (usually I/O)
- **no signal can kill it**
Common causes:
- dead or slow disk
- hung NFS or network mount
- blocked storage path
Route:
- `storage-recovery-playbook.md`
- possibly `process-control-playbook.md`
Goal:
- fix or remove the blocking I/O condition
- or, if unavoidable, plan a reboot
Proof:
- D-state clears or system is clean after controlled reboot

### Fork D — Service-managed respawn
Signals:
- process keeps coming back after kill
- `systemctl status` shows restart policy
Route:
- `service-recovery-playbook.md`
Goal:
- stop the service
- fix the root cause
- then start it cleanly
Proof:
- process no longer respawns
- service is stable

### Fork E — Process storm / fork loop
Signals:
- many similar processes appear rapidly
- killing one does not reduce count
Route:
- `process-control-playbook.md`
Goal:
- stop the source
- stabilize the system
Proof:
- process count stops exploding
- load returns to normal

---

## 🚫 Forbidden Actions (Diagnosis Phase)

- Do not spam `kill -9`.
- Do not assume every PID is killable.
- Do not reboot before classifying, unless the system is completely wedged.
- Do not treat zombies as “running processes”.

---

## 🧯 Recovery Principles

- Always fix the **cause**, not the stuck symptom.
- If it’s D-state:
  - you are fixing **I/O or kernel**, not the process.
- If it’s a zombie:
  - you are fixing the **parent**, not the child.
- If it’s service-managed:
  - you are fixing the **unit**, not the PID.

---

## ✅ Verification (Required Proof)

- The problematic process:
  - is gone, **or**
  - is no longer stuck, **or**
  - is no longer respawning
- System health checks:

  uptime
  ps aux | head -n 10

- If storage or mounts were involved:

  df -h

- If a service was involved:

  systemctl status <unit> --no-pager
  systemctl --failed

Define “healthy” as:
- no stuck D-state backlog
- no zombie buildup
- no respawn loop
- no runaway load

---

## 🧾 Post-Incident Debrief

Answer:

- What was the process state?
- Why did signals fail or succeed?
- Which failure bucket was this?
- What was the real root cause?
- What prevents recurrence?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Treating zombies like live processes
- Assuming SIGKILL can stop kernel waits
- Killing symptoms while ignoring blocked I/O
- Rebooting without understanding why (unless forced)

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** recovery and verification.

Do **not** use this section while solving the incident.

### If you misread process states or signals:
- Drill:
  - `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-4-process-model.md`

### If the root cause was blocked I/O or storage:
- Drill:
  - `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-11-storage-recovery.md`

### If a service kept respawning:
- Drill:
  - `linux/LFCS-training/execution-drills/services-and-logging.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-6-services-and-systemd.md`

Purpose of this section:
- improve state classification speed
- prevent “kill-first” reflexes
- strengthen root-cause thinking

---
