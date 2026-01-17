# 🧪 LFCS Practice Scenario F — Memory Pressure

**Mental mode:** Incident response under resource exhaustion  
**Skill:** Prove or disprove memory pressure using signals, not guesses.

---

## 🎯 Scenario

The system is **slow, laggy, or timing out**.

Some processes are still running.

Nothing obvious is “crashed”.

You are told:

> “We think it’s a memory problem.”

Your job is to **prove or disprove that claim using evidence.**

---

## 🧠 The Golden Rule

> **Never decide based on “used memory”.**  
> Decide based on **pressure signals**.

You trust:

- `MemAvailable`
- `vmstat` (si/so)
- PSI (`/proc/pressure/memory`)
- `memory.events`
- `memory.pressure`
- RSS (per-process real usage)

You ignore:

- `MemFree`
- VSZ / VmSize
- “It looks big”

---

## 🧭 Phase 1 — Is the system under memory pressure?

### Step 1 — Check global memory health

    free -h

Interpretation:

- Look at **MemAvailable**
- If MemAvailable is healthy → memory is probably not the problem

---

### Step 2 — Check swap and reclaim activity

    vmstat 1 5

Focus on:

- `si` = swap in
- `so` = swap out
- `swpd` = swap used
- `wa` = IO wait
- `r` = run queue

Interpretation:

- If `si` and `so` are **0** → memory is not under pressure
- If `si/so` are **non-zero** → real memory pressure exists

---

### Step 3 — Check PSI (Pressure Stall Information)

    cat /proc/pressure/memory

Focus on:

- `some avg10/60/300`
- `full avg10/60/300`

Interpretation:

- If averages are **0.00** → no active memory pressure
- If averages are **non-zero** → tasks are being stalled due to memory

> PSI answers: “Is the kernel struggling to satisfy memory right now?”

---

## 🧭 Phase 2 — Is this global or local (cgroup/container)?

### Step 4 — Check cgroup pressure if applicable

    cat /sys/fs/cgroup/memory.pressure
    cat /sys/fs/cgroup/memory.events
    cat /sys/fs/cgroup/memory.max
    cat /sys/fs/cgroup/memory.current
    cat /sys/fs/cgroup/memory.peak

Interpretation:

- `memory.events: max > 0` → hitting the budget
- `oom_kill > 0` → hard OOM happened
- `memory.peak == memory.max` → the wall was hit
- `memory.pressure` non-zero → real cgroup pressure occurred

> You can have **severe cgroup memory pressure even if the machine has tons of free RAM.**

---

## 🧭 Phase 3 — Find the actual memory consumers

### Step 5 — Find top RSS users

    ps aux --sort=-%mem | head -n 15

Remember:

- Trust **RSS**, not VSZ
- VSZ is virtual address space, not real RAM usage

---

### Step 6 — Inspect a specific process deeply

    cat /proc/<PID>/status | egrep -i "VmRSS|VmSize|RssAnon|RssFile|VmSwap"

Interpretation:

- `VmRSS` = real RAM usage
- `RssAnon` = heap/stack
- `RssFile` = mapped files
- `VmSwap` > 0 = swapped out pages → pressure

---

## 🧭 Phase 4 — Decide what kind of memory incident this is

### Decision Matrix

| What you see | What it means | What you do |
|--------------|---------------|-------------|
| High usage, no PSI, no swap | Healthy | Do nothing |
| PSI > 0, si/so > 0 | Real memory pressure | Find hogs, reduce load |
| memory.events max++, no oom_kill | Hitting cgroup limit | Raise limit or fix app |
| oom_kill > 0 | Hard OOM | Fix memory leak or limit |
| Global fine, local PSI | Container budget issue | Adjust limits |

---

## 🧭 Phase 5 — Verify after changes

After mitigation:

    free -h
    vmstat 1 5
    cat /proc/pressure/memory

You want to see:

- `si/so` back to 0
- PSI averages decaying to 0
- MemAvailable stable

---

## 🧠 One-Sentence Operator Summary

> “When a system feels slow, first prove whether memory is under pressure using PSI and swap activity. If not, it’s not a memory problem.”

---

## ✅ What This Scenario Trains

- You do not panic
- You do not guess
- You prove pressure
- You identify scope (global vs cgroup)
- You identify real consumers (RSS)
- You make a **correct** decision

This is **exactly** how real production memory incidents are triaged.

---

## 🏁 Pass Condition

You can:

- Prove whether memory pressure exists
- Prove whether it is global or scoped
- Identify the actual consumers
- Choose the correct remediation path
- Verify recovery using signals

That is memory incident fluency.

---

