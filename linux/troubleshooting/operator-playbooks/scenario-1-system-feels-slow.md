# 🧰 Operator Playbook — Scenario 1: “System Feels Slow — Is It Memory?”

**Goal:** Prove or disprove **memory pressure** before touching anything.  
**Golden rule:** Never decide based on “used memory”. Decide based on **pressure signals**.

---

## 🧠 Mental Model

A system can feel slow because of:

- CPU pressure
- I/O pressure
- Memory pressure
- Lock contention
- External dependencies

**High memory usage ≠ memory pressure.**  
**Memory pressure = tasks are being stalled because memory can’t be provided fast enough.**

The kernel exposes this truth via:

- PSI (Pressure Stall Information)
- Swap activity
- Reclaim behavior
- OOM / cgroup enforcement signals

---

## 🧭 Phases (Operator Loop)

---

## Phase 1 — Symptom

**Questions**
- What exactly feels slow? (login, shell, app, kubectl, ssh, browser, service?)
- Is it global or just one app / container?

**Play**
- Do nothing yet. Don’t guess. Prepare to measure.

---

## Phase 2 — Global Triage (30-second truth)

### Step 1 — Check PSI (the ground truth)

**Play**
  
  cat /proc/pressure/memory

**Interpretation**
- If `some` and `full` averages are **0.00** → **no memory pressure right now**
- If averages are **non-zero** → **real memory pressure exists**

> PSI answers: “Are tasks being stalled because memory can’t be satisfied fast enough?”

---

### Step 2 — Check swap activity

**Play**
  
  vmstat 1 5

**Focus columns**
- `si` = swap in
- `so` = swap out
- `swpd` = swap in use

**Interpretation**
- If `si` and `so` are **0** → memory is **not** the problem
- If `si` or `so` are **non-zero** → memory pressure is real

> Mental shortcut: **If si/so are zero, memory is not your problem.**

---

### Step 3 — Check global availability

**Play**
  
  free -h

**Interpretation**
- Look at **MemAvailable**, not MemFree.
- If MemAvailable is healthy → system is not globally starved.

---

## Phase 3 — Decision Gate #1

### Case A — No memory pressure signals

**You see:**
- PSI averages = 0
- vmstat si/so = 0
- MemAvailable healthy

**Conclusion:**
> ❌ This is **not** a memory problem.

**Next move:**
- Switch to CPU playbook or I/O playbook.

---

### Case B — Memory pressure signals present

**You see:**
- PSI averages > 0
- or vmstat si/so > 0
- or system feels sluggish with reclaim activity

**Conclusion:**
> ✅ This **is** a memory pressure investigation.

Proceed.

---

## Phase 4 — Scope: Global vs Local (cgroup / container)

### Step 4A — Is the whole machine under pressure?

**Play**
  
  cat /proc/pressure/memory

If this shows pressure → it’s **global**.

---

### Step 4B — Or is it a container / cgroup?

**Play**
- Identify the workload cgroup (Kubernetes, systemd, etc)
- Check:

  cat /sys/fs/cgroup/<group>/memory.pressure  
  cat /sys/fs/cgroup/<group>/memory.events  
  cat /sys/fs/cgroup/<group>/memory.max  
  cat /sys/fs/cgroup/<group>/memory.current  
  cat /sys/fs/cgroup/<group>/memory.peak

**Interpretation**
- `memory.events: max` increasing → hitting budget
- PSI non-zero in cgroup but not globally → **container budget issue**
- `oom_kill > 0` → hard OOM inside cgroup

---

## Phase 5 — Find the Consumers

### Step 5A — Top RSS users

**Play**
  
  ps aux --sort=-%mem | head

> Trust **RSS**, not VSZ.

---

### Step 5B — Deep inspect a suspect

**Play**
  
  cat /proc/<PID>/status | egrep -i "vmrss|vmsize|rssanon|rssfile|vmswap"

**Interpretation**
- VmRSS = real RAM usage
- VmSwap > 0 = swapped (pressure evidence)
- RssAnon vs RssFile = heap vs file-backed

---

## Phase 6 — Decide the Fix Path

### Possibilities

1) **Runaway process**
- Memory leak or uncontrolled growth
- Fix app or restart service

2) **Too many heavy processes**
- Reduce load, scale horizontally, move workload

3) **Container limit too small**
- memory.events max++ but global system is fine
- Raise limit or fix app memory usage

4) **Legitimate memory exhaustion**
- Add RAM or reduce workload footprint

---

## Phase 7 — Verify

**Must-haves**
- PSI averages go back to 0
- vmstat si/so return to 0
- System responsiveness returns
- No further growth in memory.events or VmSwap

---

## 🧠 The Decision Matrix

| What you see | What it means | What you do |
|---------------|--------------|-------------|
High usage, no PSI, no swap | Healthy | Do nothing |
PSI > 0, si/so > 0 | Real memory pressure | Find hogs, reduce load |
memory.events max++, no oom_kill | Hitting cgroup limit | Raise limit or fix app |
oom_kill > 0 | Hard OOM | Fix memory leak or limits |
Global fine, local PSI | Container budget issue | Adjust limits |

---

## 🏆 The Golden Rule

Never decide based on:

- “Used memory”
- MemFree
- VSZ / VmSize
- “It looks big”

Always decide based on:

- PSI
- vmstat si/so
- MemAvailable
- memory.events
- memory.pressure
- RSS

---

## 🏁 One-Sentence Operator Summary

“When a system feels slow, first prove whether memory is under pressure using PSI and swap activity. If not, it is not a memory problem.”

---
