# ⚙️ Process Control Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/process-control-playbook.md`  
**Purpose:** Stabilize a system by diagnosing and controlling **runaway, stuck, or pathological processes** using a **safe, exam-ready operator flow**.

---

## 🎯 Scope

Use this playbook when:

- CPU is pegged
- Memory pressure / OOM risk
- Process won’t die / stuck
- System feels slow due to process behavior
- Too many processes / fork-like behavior
- Zombie processes observed

This playbook orchestrates the following canonical drill surfaces:

- `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (for practice validation):

- `linux/LFCS-training/failure-scenarios/scenario-a-system-feels-slow.md`
- `linux/LFCS-training/failure-scenarios/scenario-d-process-wont-die.md`
- `linux/LFCS-training/failure-scenarios/scenario-e-cpu-pegged.md`
- `linux/LFCS-training/failure-scenarios/scenario-f-memory-pressure.md`

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Observe**
2. **Identify the offender**
3. **Classify the failure mode**
4. **Stabilize quickly**
5. **Correct the root cause**
6. **Verify**
7. **Make persistent**
8. **Rollback if needed**

Never start by killing random PIDs.

---

## 0) Inputs

You must know or determine:

- Symptom: CPU / memory / “won’t die” / general slowness
- Offending process name if known (optional)
- Whether this is a service (systemd unit) or a standalone process

---

## 1) Observe System State

CPU / load:

    uptime
    top

Memory:

    free -h

Disk I/O clues (quick signal):

    iostat
    vmstat 1 5

Branch:

- If **CPU pegged** → go to **Section 2**
- If **memory pressure** → go to **Section 3**
- If **process won’t die** → go to **Section 4**
- If **general slowness** → go to **Section 5**

---

## 2) CPU Pegged Flow

Identify top CPU consumers:

    ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -n 15

If offender is a service:

    systemctl status <service>

Stabilize (least destructive first):

- Reduce priority:

    renice +10 -p <pid>

If still pegged:

- Send TERM:

    kill -TERM <pid>

If still alive:

- Send KILL:

    kill -KILL <pid>

Verify CPU recovery:

    top
    ps -eo pid,comm,%cpu --sort=-%cpu | head

Then go to **Section 6** (Root Cause).

---

## 3) Memory Pressure Flow

Confirm pressure:

    free -h
    ps -eo pid,ppid,comm,%mem,%cpu --sort=-%mem | head -n 15

Check OOM activity (signals):

    dmesg | tail -n 50

Stabilize (least destructive first):

- Reduce priority:

    renice +10 -p <pid>

If one process is clearly leaking / exploding:

- TERM, then KILL if needed:

    kill -TERM <pid>
    kill -KILL <pid>

Verify recovery:

    free -h
    top

Then go to **Section 6** (Root Cause).

---

## 4) Process Won’t Die Flow

Attempt graceful stop:

    kill -TERM <pid>

If still alive:

    kill -KILL <pid>

If KILL does not work:

- Check state:

    ps -o pid,ppid,stat,comm -p <pid>

Interpretation:

- `D` (uninterruptible sleep): usually I/O wait; KILL won’t work until kernel returns
- `Z` (zombie): process already dead; must address parent
- `T` (stopped): may need CONT or correct control path

If zombie:

- Identify parent:

    ps -o pid,ppid,stat,comm -p <pid>

- Address parent process (restart service or parent):

    kill -TERM <ppid>

If uninterruptible sleep:

- Identify I/O dependency (quick checks):

    lsof -p <pid>
    dmesg | tail -n 50

Proceed to **Section 6** (Root Cause) or, if system is unstable, **Section 7** (Escalation).

---

## 5) General “System Feels Slow” Flow

Check load vs CPU:

    uptime

Identify resource bottleneck quickly:

- CPU heavy:

    ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -n 15

- Memory heavy:

    ps -eo pid,ppid,comm,%mem,%cpu --sort=-%mem | head -n 15

- Many processes:

    ps -e --no-headers | wc -l

If offender is a service:

    systemctl status <service>

Stabilize as needed (renice / stop service / kill offender), then go to **Section 6**.

---

## 6) Root Cause Classification

Classify offender:

### A) Standalone user process
Action:
- Stop/kill
- Fix ownership/permissions, environment, cron, or user behavior
- If recurring, inspect scheduler:

    crontab -l
    ls -l /etc/cron.*

### B) systemd service process
Action:
- Use systemd, not raw kills:

    systemctl status <service>
    journalctl -u <service> --no-pager -n 100

- Restart service:

    systemctl restart <service>

- If recurring, inspect config and logs, then correct.

### C) Fork-like / process explosion
Signals:
- Process count spikes
- Many children with same parent

Actions:
- Identify parent:

    ps -eo pid,ppid,comm --sort=ppid | head -n 50

- Stop parent first:

    kill -TERM <parent_pid>
    kill -KILL <parent_pid>

- Verify process count normalizes:

    ps -e --no-headers | wc -l

---

## 7) Escalation and Stabilization (When Things Are Getting Worse)

If system is becoming unusable:

- Stop non-critical services (choose carefully):

    systemctl stop <service>

- Consider single-user recovery path if lockup persists.

If safe and allowed:

- Reboot can clear transient deadlocks, but only after:
  - you understand what will be lost
  - you have corrected any config or cron triggers that will re-create the incident

---

## 8) Verification

Confirm stabilization:

    uptime
    top
    free -h
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 10

If service-related, confirm health:

    systemctl status <service>
    journalctl -u <service> --no-pager -n 50

---

## 9) Persistence Check

If root cause was:

- cron / scheduling: fix and re-verify
- service config: correct, restart, re-verify
- user limits: apply policy (if appropriate for exam scope)

Ensure no temporary hacks remain (e.g., leaving critical services stopped without intent).

---

## 🔁 Rollback Strategy

If you stopped or reniced the wrong thing:

- Start service again:

    systemctl start <service>

- Reset nice value (example):

    renice 0 -p <pid>

Re-check:

    top
    systemctl status <service>

---

## ✅ Completion Criteria

- CPU and memory are stable
- Offending process is corrected or controlled
- Services are in intended states
- Logs show no ongoing restart/crash loop

---

## 🧠 Exam Safety Rules

- Prefer systemd controls for services
- Use renice before kill when possible
- Treat `D` state as I/O/kernel wait: killing may not work
- Verify after every action
- Avoid unnecessary reboots

---

## 🧱 This Playbook Composes From

- processes-logs-and-scheduling.md
- services-and-logging.md
- essential-commands.md

This is a **composition layer**, not a source of primitives.

---
