# 🧠 Scenario 6 — Memory Usage Keeps Growing (Leak / Creep)

**Mental mode:** Detecting leaks vs normal growth vs cache behavior  
**Failure class:** Gradual memory pressure  
**Goal:** Decide whether memory growth is:
- normal and harmless
- cache-related
- or a real leak that will eventually cause an outage

---

## 🎯 The Symptom

- Over hours or days:
  - Memory usage keeps going up
  - The system (or container) gets slower
  - Eventually OOM or cgroup kills happen
- There is **no sudden spike** — just steady growth.

---

## 🧠 The Golden Rule

> High memory usage is not the problem.  
> **Growing memory pressure** is the problem.

You decide using:
- MemAvailable
- RSS over time
- Swap activity
- PSI
- (In containers) cgroup memory.events and memory.pressure

You **do not** decide using:
- MemFree
- VSZ / VmSize
- “It looks big”

---

## 🧪 Phase 1 — Prove Whether There Is Real Pressure

### 1) Check global memory health

    free -h

Look at:
- **MemAvailable** (not MemFree)
- Swap usage

### 2) Check pressure signals

    vmstat 1 5

Watch:
- si / so (swap in / out)
- wa (I/O wait)

    cat /proc/pressure/memory

Look at:
- some avg10 / avg60 / avg300
- full avg10 / avg60 / avg300

### Decision

- If:
  - PSI averages = 0
  - si/so = 0
  - MemAvailable is healthy

→ **This is not a memory incident yet.**  
It may still be a leak, but it is not causing pressure **right now**.

- If:
  - PSI > 0
  - si/so > 0
  - MemAvailable shrinking

→ **This is real memory pressure. Continue.**

---

## 🔍 Phase 2 — Identify the Growing Process

### 1) Get top memory users

    ps aux --sort=-%mem | head

### 2) Inspect the top suspect

    ps -o pid,user,stat,etime,%mem,rss,cmd -p PID

Focus on:
- **RSS**
- **Elapsed time**

### 3) Deep inspect via /proc

    cat /proc/PID/status | egrep -i "VmRSS|VmSize|RssAnon|RssFile|VmSwap"

You care about:
- **VmRSS** → real memory usage
- **RssAnon** → heap / app memory
- **VmSwap** → swapped pages

---

## 📈 Phase 3 — Prove It Is Actually Growing

A leak is **growth over time**, not a big number.

### Take snapshots:

    ps -o pid,rss,cmd -p PID
    sleep 60
    ps -o pid,rss,cmd -p PID

Or:

    watch -n 10 'ps -o pid,rss,cmd -p PID'

### Decision

- If RSS:
  - grows steadily → **leak or unbounded growth**
  - stays flat → not a leak
  - goes up and down → workload-dependent or cache

---

## 🧱 Phase 4 — Distinguish the 3 Common Cases

### Case A — File cache growth (harmless)

Signs:
- MemAvailable is still healthy
- RssFile grows more than RssAnon
- PSI = 0

Meaning:
- Kernel is using RAM as cache
- This is normal

Action:
- **Do nothing**

---

### Case B — Legit workload growth

Signs:
- RSS grows during work, stabilizes later
- Growth correlates with traffic or batch jobs
- PSI mostly 0

Action:
- Accept
- Or cap with cgroups if needed

---

### Case C — Real memory leak

Signs:
- RssAnon keeps growing
- RSS never comes down
- PSI eventually rises
- Swap starts being used
- Eventually OOM or cgroup kills

Action:
- Restart the service (short term)
- Fix the app (real solution)
- Add memory limits (blast radius control)

---

## 🧨 Phase 5 — Container / cgroup Variant

If this is a container or service with limits:

    cat /sys/fs/cgroup/.../memory.current
    cat /sys/fs/cgroup/.../memory.peak
    cat /sys/fs/cgroup/.../memory.events
    cat /sys/fs/cgroup/.../memory.pressure

Evidence of leak pressure:
- memory.peak hitting memory.max
- memory.events max increasing
- memory.pressure PSI averages > 0

---

## 📊 The Decision Matrix

| What you see | What it means | What you do |
|--------------|---------------|-------------|
| High usage, no PSI, no swap | Healthy | Do nothing |
| RSS growing, no pressure yet | Early leak | Plan fix |
| PSI > 0, swap active | Real pressure | Mitigate now |
| memory.events max++ | Hitting cgroup limit | Raise limit or fix app |
| oom_kill > 0 | Hard failure | Fix leak immediately |

---

## 🏁 The Operator Rule

> Memory leaks are diagnosed by **trend**, not by size.

You trust:
- MemAvailable
- RSS over time
- PSI
- vmstat si/so
- cgroup memory.events

You ignore:
- MemFree
- VSZ / VmSize
- “It looks big”

---

## 🧠 One-Sentence Operator Summary

> “If memory keeps growing, prove whether it is causing pressure using PSI and swap. Then prove which process’s RSS is growing over time. Size does not matter — **trend does**.”

---

## 🧾 Files That Prove Your Case

    free -h
    vmstat 1 5
    cat /proc/pressure/memory
    ps aux --sort=-%mem | head
    cat /proc/PID/status
    watch ps -o pid,rss,cmd -p PID

