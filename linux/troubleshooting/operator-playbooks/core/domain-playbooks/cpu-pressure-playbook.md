# 🧠 CPU Pressure — Operator Playbook

**Domain:** CPU scheduling and execution capacity  
**Mental mode:** Saturation, not utilization  
**Goal:** Determine whether the system can schedule work fast enough to keep up with demand

---

## 📌 What CPU Pressure Actually Means

CPU pressure is **not** “high CPU usage”.

CPU pressure means:

> The system has **more runnable work than the scheduler can execute** in time.

Key consequences:

- Latency increases everywhere
- Interactivity collapses
- “Everything feels slow”
- Timers slip, queues grow, retries compound

A system can be:
- At **100% CPU** and perfectly healthy
- At **30% CPU** and completely saturated (due to throttling, steal, or scheduling pathologies)

You must reason about:
- **Run queue depth**
- **Scheduler delay**
- **Throttling**
- **Steal time**
- **PSI**

Not just `%us`.

---

## 🔥 Primary Fast Signals

Run these immediately:

    uptime
    top
    vmstat 1
    cat /proc/pressure/cpu
    mpstat -P ALL 1 3

Interpretation:

- Load average >> number of cores → runnable backlog
- `vmstat`:
  - `r` = runnable processes (this is the money column)
  - If `r` > cores for sustained time → saturation
- PSI CPU:
  - Non-zero `some` or `full` → tasks delayed by CPU contention
- `mpstat`:
  - Look for:
    - high `%usr` / `%sys`
    - high `%steal`
    - suspiciously low idle but poor throughput

---

## 🧠 The Mental Model

The Linux scheduler:

- Has **N CPUs**
- Maintains **run queues**
- Tries to fairly schedule runnable tasks

CPU pressure exists when:

> Runnable tasks accumulate faster than CPUs can drain them.

This manifests as:

- Growing run queue
- Increasing scheduling latency
- Collapsing tail latency
- User-visible “lag”

---

## 🧭 Differentiation: CPU vs Memory vs IO

### Looks like CPU pressure if:

- `vmstat r` is high
- PSI CPU shows pressure
- Load average is high
- Tasks are in `R` state
- System responds slowly but commands *do* eventually return

### Looks like IO pressure instead if:

- Tasks stuck in `D` state
- `iowait` is high
- Load is high but CPU usage is low
- Commands hang for long periods

### Looks like memory pressure instead if:

- You see reclaim activity
- You see kswapd
- You see OOMs
- You see high `si/so` in `vmstat`

---

## 🧪 Deep Inspection Commands

### Scheduler view

    cat /proc/schedstat
    cat /proc/loadavg

### Per-process CPU

    top -H
    ps -eo pid,ppid,cmd,stat,pcpu,psr --sort=-pcpu | head

### Cgroup throttling (containers!)

    cat /sys/fs/cgroup/cpu.stat
    cat /sys/fs/cgroup/*/cpu.stat

Look for:
- `nr_throttled`
- `throttled_usec`

### Steal time (VMs)

    mpstat 1

If `%steal` > a few percent sustained:
- You do not own the CPU
- The hypervisor is oversubscribed

---

## 🧯 Common Root Cause Classes

1. **Runaway compute**
   - Infinite loops
   - Explosive retries
   - Bad input sizes
   - Crypto / compression storms

2. **Too much parallelism**
   - Thread pools unbounded
   - Fork storms
   - Queue consumers scaling without limits

3. **Throttling**
   - Cgroup CPU quotas
   - Kubernetes limits
   - Burstable pods hitting caps

4. **Steal time**
   - Oversubscribed hypervisor
   - Noisy neighbors

5. **Scheduler pathologies**
   - Extreme process counts
   - RT tasks starving CFS
   - CPU affinity misconfiguration

---

## 🛑 Stabilization Actions (In Order)

1. **Identify top consumers**

        top
        top -H

2. **Stop or renice obvious offenders**

        kill -STOP <pid>
        renice +10 <pid>

3. **If containerized: check throttling**

        kubectl top pods
        kubectl describe pod ...

4. **Reduce parallelism**
   - Scale down workers
   - Clamp thread pools
   - Reduce concurrency knobs

5. **If steal time:**
   - Move the workload
   - Resize the VM
   - You cannot fix this inside the guest

---

## ⚠️ Dangerous Misinterpretations

- “CPU is at 100%, that must be the problem”
  - No. 100% is normal if throughput is good.

- “Load is high so CPU is slow”
  - Load includes D-state (IO blocked) tasks.

- “Idle is low so we need more CPUs”
  - Not if you are throttled or stolen from.

---

## 🧨 When CPU Pressure Becomes Systemic

You will see:

- SSH lag
- Systemd timeouts
- Missed heartbeats
- Watchdogs firing
- Distributed systems flapping

At this point:

> You are no longer debugging an app.  
> You are debugging **scheduling capacity**.

---

## 🧱 Escalation Criteria

Escalate or drain the node if:

- PSI CPU `full` is sustained
- Run queue stays > 2× cores
- System is no longer operable interactively
- You cannot reduce load quickly

In Kubernetes:

> Drain the node. This is a capacity failure.

---

## 🧠 Canonical Summary

- CPU pressure = **scheduler saturation**
- Watch:
  - run queue
  - PSI CPU
  - throttling
  - steal
- `%CPU` is a **secondary** signal
- Always ask:
  > “Can the scheduler keep up with demand?”

---

## 🧭 This Domain Explains These Scenarios

- “CPU pegged”
- “System feels laggy”
- “Everything is slow but memory is fine”
- “Requests timing out under load”
- “Node randomly misses heartbeats”

All of these reduce to:

> The scheduler cannot run work fast enough.

