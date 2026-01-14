# 💀 OOM Killer — Out Of Memory, What It Really Means

## 🎯 Purpose

This document explains:

- What **OOM** actually is
- When and why the **kernel kills processes**
- How this differs from “high memory usage”
- How to diagnose **real OOM events**
- How this interacts with **cgroups, containers, and limits**

If you understand this file, you will never again be confused by:
> “The system had free RAM but a process was OOM-killed.”

---

## 🧠 The Core Mental Model

**OOM does NOT mean:**
- “RAM is full”

**OOM means:**
> The kernel cannot reclaim memory fast enough to satisfy allocations and must kill something to survive.

Linux will try, in order:

1) Reclaim page cache
2) Reclaim slab
3) Swap (if allowed)
4) Compact memory
5) Stall and retry
6) **Kill a process (OOM killer)** ← last resort

---

## ⚠️ High Memory Usage ≠ Memory Pressure ≠ OOM

- High memory usage is normal
- Memory pressure is when the kernel is struggling to keep up
- OOM is when **the kernel gives up and kills something**

You diagnose:

- Pressure → with PSI, vmstat, MemAvailable
- OOM → with logs and kill events

---

## 🔍 How To Recognize A Real OOM Event

### 1) Kernel log

    dmesg | grep -i oom
    journalctl -k | grep -i oom

Typical messages:

    Out of memory: Kill process 12345 (python) score 987 or sacrifice child
    Killed process 12345 (python) total-vm:..., anon-rss:...

### 2) Service logs

If it was a service or container:

    journalctl -u servicename

Or in Kubernetes:

    kubectl describe pod ...

---

## 🧠 How The Kernel Chooses What To Kill

The kernel assigns an **oom_score** to processes based on:

- Memory usage (RSS)
- Whether it is root
- Whether it is a kernel helper
- Whether it is marked important

You can inspect:

    cat /proc/<PID>/oom_score
    cat /proc/<PID>/oom_score_adj

Higher score = more likely to be killed.

---

## 🧱 Cgroups: The Most Important Modern Case

A process can be OOM-killed **even if the machine has tons of free RAM**.

Why?

Because:

> **cgroups enforce memory budgets.**

If a process group exceeds:

    memory.max

Then the kernel enforces it:

- Reclaim
- Stall
- **Kill inside the cgroup**

This is:

- Docker behavior
- Kubernetes pod OOMKills
- systemd service limits

---

## 🔎 How To Prove It Was A Cgroup OOM

Check:

    cat /sys/fs/cgroup/<group>/memory.events

Look for:

    oom
    oom_kill

Also check:

    memory.max
    memory.current
    memory.peak

---

## 🧠 Two Different Failure Modes

### 1) Hard-limit pressure without kill

Evidence:

- memory.events: max increases
- oom_kill = 0
- PSI shows pressure

Meaning:

> Kernel is enforcing the limit, but workload survives.

### 2) OOM kill

Evidence:

- oom_kill > 0
- Process disappears
- Kernel logs show kill message

Meaning:

> Kernel had no other option.

---

## 🧠 Operator Decision Tree

If a process died:

1) Check kernel logs for OOM
2) Check cgroup memory.events
3) Check memory.max vs memory.peak
4) Decide:

- Is this a **global memory shortage**?
- Or a **cgroup / container budget issue**?
- Or a **memory leak**?

---

## 🧠 The Golden Operator Rules

- OOM is a **last resort**
- OOM is not about “used memory”
- OOM is about **allocation failure under pressure**
- Containers are **much more likely** to hit OOM due to limits

---

## 🧠 One-Sentence Summary

> OOM is not “out of RAM” — it is “the kernel cannot reclaim memory fast enough and must kill something to survive.”

---

## ✅ Practical Checklist

When you see a killed process:

- Check kernel logs
- Check memory.events
- Check memory.max / memory.peak
- Check PSI
- Decide: leak, limit, or real system pressure

---

## 🏁 Outcome

After this file, you should be able to explain:

- Why OOM happened
- Who enforced it
- Whether it was avoidable
- And what to fix

That is real operator-level memory understanding.

