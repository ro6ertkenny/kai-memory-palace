# 🐘 Finding Memory Hogs
*How to identify which processes are actually consuming RAM*

---

## 🎯 Purpose

This document teaches the **operator method** for answering one question:

> “Which processes are actually using memory — and how much does each one really use?”

It is not about:
- virtual address space
- theoretical limits
- “looks big”

It is about:
- **real RAM consumption**
- **memory pressure contribution**
- **who is actually hurting the system**

---

## 🧠 Core Mental Model

Memory pressure comes from:

> **The sum of RSS across processes vs available RAM**

Not:
- VSZ
- VmSize
- MemFree
- “big looking numbers”

Always think in:

- **RSS (Resident Set Size)** → real RAM
- **MemAvailable** → global headroom
- **Swap usage** → pressure indicator

---

## 🔎 The Primary Tool: `ps`

### Top memory consumers by RSS

    ps aux --sort=-%mem | head -n 20

Key columns:

- `%MEM` → percentage of RAM
- `RSS`  → resident memory in KB (this is the real number)
- `VSZ`  → virtual size (mostly noise)

---

## ⚠️ The VSZ Trap

Example:

    VSZ: 1461511284
    RSS:    594872

Meaning:

- The process *can* address ~1.4 TB
- The process is actually using ~580 MB of RAM

> **Always trust RSS. Ignore VSZ for pressure analysis.**

VSZ includes:
- mmap reservations
- shared libraries
- unused address space
- guard regions

---

## 🧭 Operator Workflow: Find the Hog

### Step 1 — Check global health

    free -h

Focus on:

- `MemAvailable`
- Swap usage

If MemAvailable is healthy and swap is 0 → memory is not the problem.

---

### Step 2 — List top consumers

    ps aux --sort=-%mem | head -n 20

Look for:

- unusually large RSS
- multiple instances of the same app
- runaway processes

---

### Step 3 — Deep inspect a suspect

Pick a PID and inspect:

    cat /proc/<PID>/status | egrep -i "VmRSS|VmSize|RssAnon|RssFile|VmSwap"

What matters:

- `VmRSS`   → real RAM used
- `RssAnon` → heap / stacks / runtime
- `RssFile` → mapped files / shared libs
- `VmSwap`  → swapped pages (pressure indicator)

---

## 🧱 How to Interpret the Numbers

### Healthy process looks like:

- VmRSS: reasonable for its role
- VmSwap: 0
- RssAnon / RssFile: sane proportions

### Suspicious process looks like:

- VmRSS: very large (GBs)
- VmSwap: non-zero
- RssAnon: growing steadily

That indicates:
- memory leak
- runaway workload
- mis-sized cache
- or pathological behavior

---

## 🧠 The Golden Rules

- **Memory pressure is caused by RSS, not VSZ**
- **One huge process or many medium ones can both kill a system**
- **Swap usage means the kernel is already under stress**
- **MemFree is irrelevant**
- **MemAvailable is king**

---

## 🚨 What a Real Incident Looks Like

You will see:

- MemAvailable shrinking
- Swap being used
- One or more processes with large RSS
- System becoming sluggish

Your job:

> Identify which process(es) are responsible and decide whether to:
> - restart
> - reconfigure
> - limit
> - or kill

---

## 🧭 Relationship to Other Docs

- `memory-inspection.md` → teaches *how memory works*
- This doc → teaches *who is using it*
- `swap-and-reclaim.md` → teaches *what the kernel does under pressure*
- `oom-killer.md` → teaches *what happens when things go too far*

---

## ✅ Outcome

After this document, you should be able to:

- Prove which processes are consuming RAM
- Ignore misleading virtual size numbers
- Identify real memory hogs confidently
- Support decisions with evidence, not guesses

That is **operator-grade memory analysis**.

---

## 📎 Canonical Commands (Muscle Memory)

    free -h
    ps aux --sort=-%mem | head
    cat /proc/<PID>/status

---

## 🧠 One-Sentence Operator Summary

> “Memory hogs are identified by RSS, not by VSZ, and only RSS contributes to real memory pressure.”

---

