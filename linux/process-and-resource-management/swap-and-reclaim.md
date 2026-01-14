# 🧠 Swap & Reclaim — How Linux Survives Memory Pressure

Mental mode: **Understanding what the kernel does when RAM is tight**

---

## 🎯 Purpose

This document explains:

- What **swap** actually is (and what it is not)
- What **reclaim** is
- How Linux tries to **avoid OOM**
- How to **recognize real memory pressure**
- How to interpret:
  - `vmstat`
  - `/proc/meminfo`
  - PSI (Pressure Stall Information)
  - cgroup memory signals

This is not about “how to enable swap”.

This is about **how Linux stays alive when memory is scarce**.

---

## 🧠 The Core Mental Model

Linux does **not** think in:

“Used vs Free memory”

Linux thinks in:

**Working set vs Reclaimable vs Emergency**

When memory is needed, Linux tries (in order):

1) Reclaim **page cache**  
2) Reclaim **slab**  
3) Swap out **anonymous memory**  
4) Kill a process (**OOM killer**) ← last resort  

---

## 🧱 What Reclaim Is

**Reclaim = the kernel trying to free RAM**

It does this by:

- Dropping file cache
- Evicting slab objects
- Swapping out anonymous pages (if swap exists)

Reclaim is done mainly by:

- `kswapd` (background)
- Direct reclaim (when an allocation blocks)

---

## 🔁 What Swap Is

Swap is:

A **backing store** for anonymous memory pages.

It allows Linux to:

- Move cold memory out of RAM
- Keep the system alive under pressure
- Avoid OOM kills

Important truths:

- **Having swap is normal**
- **Using swap is the signal**

---

## ⚠️ The Operator Rule

**Swap existence is normal.  
Swap activity means pressure.**

---

## 🔍 The 3 Global Signals You Trust

### 1) `/proc/meminfo`

You care about:

- `MemAvailable` → global health
- `SwapTotal`, `SwapFree`

You **do not** diagnose from:

- `MemFree`

---

### 2) `vmstat`

Run:

    vmstat 1 5

The columns that matter:

- `si` = swap in
- `so` = swap out
- `swpd` = swap in use
- `wa` = IO wait
- `r` = runnable queue

### The Golden Shortcut

**If `si` and `so` are zero, memory is not your problem.**

---

### 3) PSI (Pressure Stall Information)

Global:

    cat /proc/pressure/memory

cgroup:

    cat /sys/fs/cgroup/<cg>/memory.pressure

You care about:

- `some avg10/60/300`
- `full avg10/60/300`

PSI answers:

**“Are tasks being stalled because memory can’t be provided fast enough?”**

Not:

- “Is RAM full?”
- “Is usage high?”

---

## 🧠 What Real Memory Pressure Looks Like

You will see:

- `MemAvailable` shrinking
- `si` / `so` non-zero
- `swpd` growing
- PSI averages > 0
- `wa` rising
- System feels sluggish

---

## 🧨 Reclaim vs OOM

### Reclaim Path

- Kernel scans pages
- Reclaims cache / anon
- Thrashes if workload keeps touching memory
- System slows
- PSI rises

### OOM Path (Last Resort)

- Kernel cannot satisfy allocations fast enough
- Reclaim fails
- Kernel **kills a process**

OOM does **not** mean:

“RAM is full”

It means:

**“The kernel cannot reclaim memory fast enough to survive.”**

---

## 🧠 vmstat Pattern Recognition

### Memory Pressure

You see:

- `si` or `so` > 0
- `swpd` growing
- `wa` rising
- `r` rising

### IO Pressure

You see:

- `b` > 0
- `wa` rising

### CPU Pressure

You see:

- `r` consistently > number of cores
- `id` near 0

---

## 🧱 cgroups Change Everything

Inside containers / systemd slices:

- There is a **memory budget**
- Enforced by `memory.max`
- You can hit **pressure and OOM** even if the machine has tons of RAM

Key files:

    memory.max
    memory.current
    memory.peak
    memory.events
    memory.pressure

### The 3 Proof Layers

- Budget: `memory.max`
- Enforcement: `memory.events` (max increments)
- Pressure: `memory.pressure` (PSI > 0)

---

## 🧠 memory.peak Is Critical

**memory.peak answers: “Did we hit the wall?”**

Not `memory.current`.

---

## 🧪 How To Prove Reclaim Is Happening

    vmstat 1 10
    cat /proc/pressure/memory
    cat /sys/fs/cgroup/<cg>/memory.pressure
    cat /sys/fs/cgroup/<cg>/memory.events

Then run a workload that exceeds the budget.

You should see:

- `max` incrementing
- PSI rising
- Possibly swap activity
- Maybe OOM

---

## 🧠 The Operator Rule Set

Diagnose memory using:

- `MemAvailable`
- `vmstat (si/so)`
- PSI
- cgroup `memory.events`
- cgroup `memory.pressure`
- RSS per process

Ignore:

- `MemFree`
- VSZ / VmSize
- “It looks big”

---

## 🏁 One-Sentence Operator Summary

**Memory pressure is diagnosed by pressure signals, not by “usage”.  
If PSI and swap are quiet, memory is not your problem.**

