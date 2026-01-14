# 🧠 Memory Inspection (Operator Workflow)

*How to inspect real memory usage, prove or disprove pressure, and avoid lying metrics.*

---

## 🎯 Purpose

This document teaches you how to **inspect memory correctly** on a live Linux system.

Not:

- “Is memory big?”
- “Is RAM mostly used?”

But:

- “Is the system under memory **pressure**?”
- “Which processes are consuming **real** RAM?”
- “Is swap involved?”
- “Are we at risk of OOM?”

---

## 🧠 The Only Mental Model That Matters

Linux memory is **not**:

> used vs free

Linux memory **is**:

> working set vs reclaimable vs pressure

Therefore:

- You **never** decide using `MemFree`
- You **never** decide using `VSZ` / `VmSize`
- You **always** decide using:
  - `MemAvailable`
  - RSS
  - swap activity
  - PSI (pressure stall information)

---

## 🥇 Step 1 — Global Memory Health

Run:

    free -h

Interpretation:

- Ignore `free`
- Look at:
  - `available`
  - `swap` usage

Then verify source of truth:

    head -n 40 /proc/meminfo

Anchor on:

- `MemTotal`
- `MemAvailable`  ← 👑 **This is the real number**
- `SwapTotal`
- `SwapFree`

### ✅ Operator Rule

If `MemAvailable` is healthy and swap is unused:

> The system is **not** under memory pressure.

---

## 🧩 Step 2 — Understand What MemAvailable Means

`MemAvailable` =

> How much memory the kernel can give to applications **without pain**

It includes:

- free pages
- reclaimable cache
- reclaimable slab

This is why:

> High “used” memory is normal and healthy.

---

## 🥈 Step 3 — Find Top Memory Consumers

Run:

    ps aux --sort=-%mem | head -n 15

Important columns:

- `RSS` (resident set size) → **real RAM used**
- `VSZ` → virtual address space (mostly meaningless for pressure)

### 🧠 Critical Rule

> Always trust **RSS**.  
> Never trust **VSZ** for memory pressure.

---

## 🧱 Step 4 — Deep Inspect a Process

Pick a PID and run:

    cat /proc/<PID>/status | egrep -i "vmrss|vmsize|vmdata|vmstk|vmswap|rss"

Key fields:

- `VmRSS`   → ✅ real RAM used
- `RssAnon` → heap, stacks, runtime
- `RssFile` → mapped files, shared libs
- `VmSize`  → virtual address space (ignore for pressure)
- `VmSwap`  → swapped out memory for this process

### 🧠 Operator Interpretation

- **VmRSS** contributes to pressure
- **VmSwap > 0** means the process has been swapped
- **VmSize** is not a pressure signal

---

## 🥉 Step 5 — Prove Whether Swap Is Involved

Check per-process:

    grep -R "VmSwap" /proc/*/status | grep -v "0 kB" || echo "No process is swapped"

Check globally:

    free -h

Check activity:

    vmstat 1 5

Interpret:

- `si` = swap in
- `so` = swap out

### ✅ Operator Rule

> If `si` and `so` are **zero**, memory is not your problem.

---

## 🧮 Step 6 — vmstat: Pressure Signals

Run:

    vmstat 1 5

Watch:

- `si` / `so` → swap activity
- `r` → run queue pressure
- `b` → blocked on I/O
- `wa` → I/O wait
- `id` → idle CPU

### 🚨 Memory Pressure Looks Like

- `si` or `so` > 0
- `swpd` growing
- `wa` rising
- system feels sluggish

---

## 🧠 Step 7 — PSI (Pressure Stall Information)

Check:

    cat /proc/pressure/memory

Fields:

- `some` → some tasks stalled
- `full` → all tasks stalled

You care about:

- `avg10`
- `avg60`
- `avg300`

### 🧠 Critical Rule

> PSI answers: “Are tasks being stalled because memory can’t be provided fast enough?”

Not:

- Is memory big?
- Is cache large?
- Is used high?

---

## 🧪 Step 8 — cgroup-Aware Inspection (Containers, systemd, Kubernetes)

Find your cgroup:

    cat /proc/self/cgroup

Inspect:

    cat /sys/fs/cgroup/<path>/memory.max
    cat /sys/fs/cgroup/<path>/memory.current
    cat /sys/fs/cgroup/<path>/memory.peak
    cat /sys/fs/cgroup/<path>/memory.events
    cat /sys/fs/cgroup/<path>/memory.pressure

Interpret:

- `memory.max`     → budget
- `memory.current` → current spend
- `memory.peak`    → did we hit the wall?
- `memory.events`  → enforcement counters (`max`, `oom_kill`)
- `memory.pressure`→ PSI inside this cgroup

### 🧠 Critical Insight

> A process can be OOM-killed **even when the machine has tons of free RAM** if its cgroup hits `memory.max`.

---

## 🧰 The Operator Decision Table

| Signal | Meaning |
|--------|---------|
| High usage, no PSI, no swap | Healthy |
| PSI > 0, si/so > 0 | Real memory pressure |
| memory.events: max++ | Hitting cgroup limit |
| oom_kill > 0 | Hard OOM |
| Global fine, local PSI | Container budget issue |

---

## 🏁 The Golden Rules

You **trust**:

- `MemAvailable`
- `RSS`
- `vmstat si/so`
- `PSI`
- `memory.events`
- `memory.pressure`

You **ignore**:

- `MemFree`
- `VSZ` / `VmSize`
- “It looks big”

---

## 🧠 One-Sentence Operator Summary

> “Never decide based on memory size. Decide based on **pressure signals**.”

---

## ✅ Outcome

After this guide, you can:

- Prove whether memory is the problem
- Identify real RAM consumers
- Detect swap and reclaim activity
- Understand cgroup memory limits
- Avoid false diagnoses

This is production-grade memory inspection.

