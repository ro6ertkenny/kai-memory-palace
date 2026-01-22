# ⚙️ Process Control Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/process-control-playbook.md`  
**Purpose:** Stabilize a system by diagnosing and controlling **runaway, stuck, or pathological processes** using a **safe, exam-ready operator algorithm**.

This is not a tutorial. This is a procedure.

---

## 🎯 Scope

Use this playbook when:

- CPU is pegged
- Memory pressure / OOM risk
- Process won’t die / appears stuck
- System feels slow due to process behavior
- Too many processes / fork-like behavior
- Zombie processes observed

This playbook composes the following drill surfaces:

- `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (practice inputs):

- `linux/LFCS-training/failure-scenarios/scenario-a-system-feels-slow.md`
- `linux/LFCS-training/failure-scenarios/scenario-d-process-wont-die.md`
- `linux/LFCS-training/failure-scenarios/scenario-e-cpu-pegged.md`
- `linux/LFCS-training/failure-scenarios/scenario-f-memory-pressure.md`

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Observe**
2. **Identify the offender**
3. **Inspect**
4. **Classify**
5. **Stabilize (minimum safe action)**
6. **Correct root cause**
7. **Verify**
8. **Make persistent (if required)**
9. **Rollback if needed**

Never start by killing random PIDs.

---

## 🧭 Global Safety Rules

- **Preserve evidence first.** Do not restart or kill before you inspect.
- **If the PID is systemd-managed, prefer `systemctl` over signals.**
- **If a suspect process is in `D` state, stop using signals and switch to storage/I/O diagnosis.**
- **Prefer smallest safe action (renice → TERM → KILL).**
- **Every action requires verification.**

---

## 0) Inputs

You must know or determine:

- Symptom class: CPU / memory / “won’t die” / general slowness
- Offending process name or PID (if known)
- Whether the process is **systemd-managed** or standalone

---

## 1) Observe System State (Low-Risk, Always First)

CPU / load:

    uptime

Memory:

    free -h

Quick process view (portable, exam-safe):

    ps aux --sort=-%cpu | head -n 15
    ps aux --sort=-%mem | head -n 15

Optional helpers if available (not guaranteed on exam images):

    top
    vmstat 1 5
    iostat

Branch:

- If **CPU pegged** → go to **Section 2**
- If **memory pressure** → go to **Section 3**
- If **process won’t die** → go to **Section 4**
- If **general slowness** → go to **Section 5**

---

## 2) CPU Pegged Flow

Identify top CPU consumers:

    ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -n 15

Select the primary suspect PID.

Inspect it:

    ps -o pid,ppid,user,stat,etime,%cpu,%mem,cmd -p <pid>

If it looks like a service:

    systemctl status <service> --no-pager

Stabilize (least destructive first):

- Reduce priority:

    renice +10 -p <pid>

Verify effect:

    ps -o pid,ni,%cpu,cmd -p <pid>

If still pegged and action is justified:

- Send TERM:

    kill -TERM <pid>

Verify:

    ps -p <pid> -o pid,stat,etime,cmd

If still alive and clearly pathological:

- Send KILL:

    kill -KILL <pid>

Verify again:

    ps -p <pid> -o pid,stat,etime,cmd

Then go to **Section 6** (Root Cause).

---

## 3) Memory Pressure Flow

Confirm pressure:

    free -h
    ps -eo pid,ppid,comm,%mem,%cpu --sort=-%mem | head -n 15

Optional signal of OOM activity:

    dmesg | tail -n 50

Select the primary suspect PID and inspect it:

    ps -o pid,ppid,user,stat,etime,%mem,rss,cmd -p <pid>

Stabilize (least destructive first):

- Reduce priority:

    renice +10 -p <pid>

If one process is clearly leaking / exploding:

- TERM, then KILL if needed:

    kill -TERM <pid>
    kill -KILL <pid>

Verify recovery:

    free -h
    ps aux --sort=-%mem | head -n 10

Then go to **Section 6** (Root Cause).

---

## 4) Process Won’t Die Flow

Attempt graceful stop:

    kill -TERM <pid>

If still alive:

    kill -KILL <pid>

If KILL does not work, inspect state:

    ps -o pid,ppid,stat,etime,cmd -p <pid>

Interpretation:

- `D` (uninterruptible sleep): signals will not help → switch to storage/I/O diagnosis.
- `Z` (zombie): process is already dead → fix the parent.
- `T` (stopped): may need CONT or parent control.
- Respawning rapidly: you are killing children, not the supervisor.

If zombie:

- Identify parent:

    ps -o pid,ppid,stat,cmd -p <ppid>

- If parent is a service: restart the service.
- If parent is a user job runner: stop the parent.

If uninterruptible sleep (`D`):

- Do not escalate signals.
- Check for I/O or storage trouble (switch playbook if needed).

After stabilization, go to **Section 6** (Root Cause).

---

## 5) General “System Feels Slow” Flow

Check load vs CPU:

    uptime

Quickly identify the dominant pressure:

- CPU:

    ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -n 15

- Memory:

    ps -eo pid,ppid,comm,%mem,%cpu --sort=-%mem | head -n 15

- Process explosion:

    ps -e --no-headers | wc -l

If offender looks like a service:

    systemctl status <service> --no-pager

Stabilize using the appropriate branch (Sections 2–4), then go to **Section 6**.

---

## 6) Root Cause Classification (After Stabilization)

Do not attempt root cause fixes until the system is stable.

Classify the offender:

### A) Standalone user process

Actions:

- Stop/kill the process.
- Fix:
  - user behavior
  - environment
  - cron / timer / scheduler

Check for schedulers:

    crontab -l
    ls -l /etc/cron.*

---

### B) systemd service process

Actions:

- Use systemd, not raw signals:

    systemctl status <service> --no-pager
    journalctl -u <service> --no-pager -n 100

- Restart or stop as appropriate:

    systemctl restart <service>

- If recurring:
  - inspect config
  - fix config
  - re-verify

---

### C) Fork storm / process explosion

Signals:

- Process count spikes
- Many children with same parent

Actions:

- Identify parent:

    ps -eo pid,ppid,comm --sort=ppid | head -n 50

- Stop the parent first:

    kill -TERM <parent_pid>
    kill -KILL <parent_pid>

- Verify normalization:

    ps -e --no-headers | wc -l

---

## 7) Escalation and System Stabilization

If the system is becoming unusable:

- Stop non-critical services (carefully):

    systemctl stop <service>

Reboot is a last resort and only after:

- You understand what will be lost
- You have fixed any cron/service/config that would re-trigger the incident

---

## 8) Verification (Mandatory Exit Ritual)

Run:

    uptime
    free -h
    ps aux --sort=-%cpu | head -n 10
    ps aux --sort=-%mem | head -n 10

If services were involved:

    systemctl --failed --no-pager
    systemctl status <service> --no-pager

Confirm:

- Original symptom is gone
- No new failure cascade exists

---

## 9) Persistence Check

If root cause was:

- cron / scheduling → fix and re-verify
- service config → correct, restart, re-verify
- user limits or policy → apply (if in exam scope)

Ensure no temporary hacks remain (e.g., leaving critical services stopped unintentionally).

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

## ✅ Completion Criteria

- CPU and memory are stable
- Offending process is corrected or controlled
- Services are in intended states
- Logs show no ongoing restart/crash loop
- You can explain:
  - what failed
  - why it failed
  - why your fix was safe
  - how you verified recovery

---

## 🧠 Exam Safety Rules

- Prefer systemd controls for services
- Use renice before kill when possible
- Treat `D` state as I/O/kernel wait: killing will not help
- Verify after every action
- Avoid unnecessary reboots

---

## 🧱 This Playbook Composes From

- processes-logs-and-scheduling.md
- services-and-logging.md
- essential-commands.md

This is a **composition layer**, not a source of primitives.

---
