# 🧠 Memory Pressure — Operator Playbook
**Domain Playbook: Diagnosing and fixing real memory pressure (not “high usage”)**

Mental mode: Evidence-driven diagnosis of whether the system (or a cgroup) is actually under memory pressure.

---

## 🧭 Operator Rule Zero

> **Never decide based on “used memory”.**  
> Decide based on **pressure signals**.

You trust:
- MemAvailable
- vmstat (si / so)
- PSI (memory.pressure)
- memory.events (cgroups)
- RSS (per-process real memory)
- Swap activity

You ignore:
- MemFree
- VSZ / VmSize
- “It looks big”

---

## 🧠 What “Memory Pressure” Actually Means

Memory pressure is **not**:
- “RAM is mostly used”
- “Cache is large”
- “One process allocated a lot”

Memory pressure **is**:
- The kernel **cannot satisfy allocations fast enough**
- Tasks are **stalling**
- The kernel is **reclaiming aggressively**
- Or a **cgroup budget is being hit**

---

## 🔁 The Operator Loop

Symptom → Evidence → Decision → Action → Verification

This playbook is only about **proving or disproving memory pressure**.

---

## 🥇 Phase 1 — Global Health Snapshot

Run:

    free -h

    grep -E 'MemTotal|MemAvailable' /proc/meminfo

Interpretation:
- **MemAvailable is the only global number that matters**
- MemFree is meaningless for diagnosis

If MemAvailable is healthy → **global memory is probably not the problem**

---

## 🥈 Phase 2 — Swap & Reclaim Signals

Run:

    vmstat 1 5

Watch these columns:
- swpd = swap in use
- si = swap in
- so = swap out
- wa = IO wait
- r = runnable processes

Interpretation:
- If **si and so are 0** → memory is not under pressure
- If **si or so > 0** → real memory pressure exists
- Rising **wa** + swap = reclaim is hurting performance

Mental shortcut:

> If si/so are zero, memory is not your problem.

---

## 🥉 Phase 3 — PSI (Pressure Stall Information)

Check global PSI:

    cat /proc/pressure/memory

Check cgroup PSI (if in containers or limited groups):

    cat /sys/fs/cgroup/<group>/memory.pressure

Interpretation:
- You care about **avg10 / avg60 / avg300**
- Non-zero averages = **tasks are being stalled**
- Totals are historical; **averages are the truth**

PSI answers:

> “Are tasks being delayed because memory cannot be provided fast enough?”

---

## 🧱 Phase 4 — Cgroup Enforcement (Containers, systemd, Kubernetes)

If running in a container or limited environment:

    cat /sys/fs/cgroup/<group>/memory.max
    cat /sys/fs/cgroup/<group>/memory.current
    cat /sys/fs/cgroup/<group>/memory.peak
    cat /sys/fs/cgroup/<group>/memory.events

Interpretation:
- memory.max = **budget**
- memory.peak = **did we hit the wall?**
- memory.events:
  - max increasing = **budget pressure**
  - oom_kill > 0 = **hard kill happened**

Critical mental model:

> A process can be OOM-killed even when the machine has tons of free RAM.

---

## 🔬 Phase 5 — Find Real Memory Consumers (RSS)

List top memory users:

    ps aux --sort=-%mem | head

Inspect a specific process:

    cat /proc/<PID>/status | egrep -i 'VmRSS|VmSize|RssAnon|RssFile|VmSwap'

Trust:
- **VmRSS** = real RAM in use
- RssAnon / RssFile = breakdown
- VmSwap = swapped pages

Ignore:
- VmSize / VSZ

Golden rule:

> **RSS creates pressure. VSZ does not.**

---

## 🔁 Phase 6 — Prove Swap Is (or Is Not) In Play

Check if anything is swapped:

    grep -R "VmSwap" /proc/*/status | grep -v "0 kB" || echo "No process is swapped"

If non-zero appears → **system is under memory pressure**

---

## 🧠 Decision Matrix

| What you see | What it means | What you do |
|--------------|---------------|-------------|
| High usage, no PSI, no swap | Healthy | Do nothing |
| PSI > 0, si/so > 0 | Real memory pressure | Find hogs, reduce load |
| memory.events max++, no oom_kill | Hitting cgroup limit | Raise limit or fix app |
| oom_kill > 0 | Hard OOM | Fix leak or increase limit |
| Global fine, local PSI | Container budget issue | Adjust limits |

---

## 🚨 What a Real Memory Incident Looks Like

You will see:
- MemAvailable shrinking
- si / so non-zero
- PSI averages > 0
- kswapd activity
- One or more processes with huge RSS
- System becoming sluggish

---

## 🧠 The One-Sentence Operator Summary

> **When a system feels slow, first prove whether memory is under pressure using PSI and swap activity. If not, it’s not a memory problem.**

---

## ✅ Verification Checklist

After any action:
- MemAvailable improved?
- vmstat si/so back to 0?
- PSI averages falling?
- memory.events stopped incrementing?
- System responsive again?

If yes → you actually fixed the problem.

---

## 🏁 Outcome

You now know how to:
- Prove memory pressure
- Disprove fake “high usage” alarms
- Diagnose cgroup vs global pressure
- Find the real offenders
- Verify recovery

This is **production-grade memory diagnosis**.

