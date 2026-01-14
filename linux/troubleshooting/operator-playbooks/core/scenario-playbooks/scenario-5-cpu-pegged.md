# 🧰 Operator Playbook — Scenario 5: “CPU Pegged”

**Primary domain:** CPU Pressure  
**Domain playbook:** core/domain-playbooks/cpu-pressure-playbook.md  
**Why this domain:** The incident is about scheduler saturation and runnable backlog, not memory or IO blocking.

---

## 🎯 Situation

> “The system is slow and CPU is at 100%.”  
> “Fans are loud.”  
> “Load is high.”  
> “Everything feels laggy.”

Your job is to decide:

- Is this **real CPU pressure** or just normal work?
- Is the system **CPU-bound** or **I/O-bound**?
- Is one process misbehaving or is this expected load?
- What is the **minimum safe action**?

---

## 🧠 Core Mental Model

High CPU usage is **not automatically a problem**.

You must answer:

- Is the CPU busy doing **useful work**?
- Or is it busy doing **runaway / broken work**?
- Or is it **waiting on I/O** and just looks busy?

---

## 🧭 Operator Phases

1. Confirm it is CPU pressure (not memory or I/O)
2. Check run queue vs core count
3. Identify top CPU consumers
4. Inspect the top process
5. Decide: expected, misbehaving, or stuck
6. Act minimally and verify

---

## 🥇 Phase 1 — Confirm It’s Actually CPU Pressure

Start with:

    uptime

Look at:

- Load average
- Compare to number of CPU cores

Then:

    vmstat 1 5

Focus on:

- r = runnable processes
- wa = I/O wait
- id = idle CPU

Interpretation:

- If r > number of cores consistently → real CPU pressure
- If wa is high → this is I/O, not CPU
- If id is near 0 → CPU is saturated

---

## 🥈 Phase 2 — Find the Culprit

    ps aux --sort=-%cpu | head

Or:

    top

Identify:

- Which PID(s) are consuming CPU
- Is it one process or many?

---

## 🥉 Phase 3 — Inspect the Top Process

    ps -o pid,ppid,user,stat,etime,%cpu,%mem,cmd -p <PID>

Ask:

- Who owns this?
- How long has it been running?
- Is this a build, scan, encode, backup, or expected workload?
- Is it part of a service or a one-off process?

If systemd-managed:

    systemctl status <service>

---

## 🧪 Phase 4 — Decide What Kind of High CPU This Is

### Case A — Expected Load (Healthy)

Examples:

- Kernel build
- Video encode
- Backup
- Large scan
- Data processing

Signals:

- CPU high
- System responsive enough
- You can explain what the process is

Action:

👉 Do nothing.

---

### Case B — Runaway / Buggy Process

Signals:

- One process pegged at 100% for a long time
- No good reason
- Repeating same work
- Possibly respawning

Action:

- Inspect logs
- Inspect parent / service
- Restart service or terminate process (gracefully first)

---

### Case C — I/O Wait Masquerading as CPU

Check:

    vmstat 1 5

If:

- wa is high
- CPU is “busy” but waiting on disk or network

Then:

👉 This is **storage or network**, not CPU.

Go to disk / I/O playbooks.

---

## 🧨 Phase 5 — If You Must Intervene

Always escalate safely:

    kill <PID>
    ps -p <PID>

If needed:

    kill -9 <PID>

Then:

- Re-check CPU
- Re-check load
- Re-check vmstat

---

## 🧠 Decision Matrix

| What you see | What it means | What you do |
|---------------|---------------|-------------|
| High CPU, explainable process | Normal | Do nothing |
| r > cores, id ~ 0 | True CPU saturation | Find and inspect top process |
| wa high | I/O bottleneck | Debug storage/network |
| One PID at 100% for long time | Likely runaway | Inspect, then restart/kill |
| Service respawns process | Supervisor-managed | Fix service, not PID |

---

## ⚠️ The Golden Rules

- High CPU is not automatically a bug.
- Always check **run queue and I/O wait** before blaming CPU.
- Never kill something until you know **what it is and who owns it**.

---

## 🧠 The One-Sentence Operator Summary

> “When CPU is pegged, first prove whether the system is CPU-bound or I/O-bound, then decide whether the top process is doing expected work or runaway work before acting.”

---

## 🧪 Muscle Memory Commands

    uptime
    vmstat 1 5
    ps aux --sort=-%cpu | head
    top
    ps -o pid,ppid,stat,etime,%cpu,%mem,cmd -p <PID>
    systemctl status <service>

---

## 🏁 Outcome

You can now:

- Distinguish real CPU pressure from I/O wait
- Identify the true CPU hog
- Decide whether high CPU is healthy or pathological
- Act without destabilizing the system

That is operator-grade CPU triage.

---
