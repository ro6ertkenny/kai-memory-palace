# 🔍 Finding Memory Hogs (Operator Guide)

## 🎯 Purpose

This document teaches you how to **identify which process is actually causing memory pressure**.

Not:
- who has the biggest VSZ
- who “looks big”
- who you *feel* is guilty

But:

> **Which process is consuming real RAM (RSS) and contributing to pressure?**

---

## 🧠 The Only Two Levels That Matter

Memory problems exist at two levels:

1) **Global pressure**
   - Is the system under memory stress?

2) **Per-process usage**
   - Which process is responsible?

You must always answer **(1) before (2)**.

---

## 🧪 Step 1 — Prove There Is Memory Pressure

Check:

    free -h

Focus on:
- `MemAvailable` → must be low to indicate real pressure

Check:

    vmstat 1 5

Look for:
- `si` or `so` > 0
- rising `wa`
- growing `swpd`

Check:

    cat /proc/pressure/memory

Look for:
- non-zero `some` or `full` averages

If **none of these show pressure**, you do **not** have a memory problem.

---

## 🔎 Step 2 — Find Top Memory Consumers (By RSS)

Run:

    ps aux --sort=-%mem | head -n 15

This sorts by **RSS usage**, not VSZ.

Key columns:
- `%MEM` → share of physical RAM
- `RSS` → real memory in use
- `VSZ` → virtual address space (mostly lies)

---

## ⚠️ Critical Mental Model: RSS vs VSZ

Example:

- VSZ: 1.4 TB
- RSS: 580 MB

This means:
- The process mapped lots of address space
- But is only using **580 MB of real RAM**

> **Always trust RSS. Ignore VSZ.**

---

## 🧬 Step 3 — Inspect a Specific Process Deeply

Pick a suspect PID and run:

    cat /proc/<PID>/status | egrep -i "vmrss|vmsize|vmswap|rss"

Important fields:
- `VmRSS` → real RAM used (this is the truth)
- `VmSize` → virtual memory (ignore for pressure)
- `RssAnon` → heap / stacks / anonymous memory
- `RssFile` → file-backed memory
- `VmSwap` → swapped-out pages (pressure signal)

---

## 🧠 Interpretation Guide

Healthy process:
- VmRSS reasonable
- VmSwap = 0
- RssAnon stable

Bad process:
- VmRSS growing over time
- VmSwap > 0
- System PSI rising
- MemAvailable shrinking

---

## 🧪 Step 4 — Check for Swapped Processes

Run:

    grep -R "VmSwap" /proc/*/status | grep -v "0 kB"

If this prints anything:
- You have **real memory pressure**
- The kernel is actively evicting memory

---

## 🧠 Step 5 — Check cgroup / Container Context

If in containers / Kubernetes / systemd:

Check:

    cat /proc/<PID>/cgroup

Then inspect:

    memory.max
    memory.current
    memory.events
    memory.pressure

A process can be killed **even when the system has tons of free RAM** if its cgroup is out of budget.

---

## 🧠 The Golden Rules

You diagnose memory using:
- `MemAvailable`
- `vmstat (si/so)`
- `PSI`
- `RSS`
- `VmSwap`

You **ignore**:
- `MemFree`
- `VSZ / VmSize`
- “It looks big”

---

## 🧠 One-Sentence Operator Summary

> “Memory hogs are identified by RSS growth under real pressure, not by who has the biggest virtual address space.”

---

## ✅ Outcome

You can now:
- Prove whether memory is actually the problem
- Identify which process is consuming real RAM
- Tell normal memory usage from dangerous memory growth
- Detect swap activity and reclaim pressure
- Avoid killing the wrong process

That is **operator-grade memory diagnosis**.

---
