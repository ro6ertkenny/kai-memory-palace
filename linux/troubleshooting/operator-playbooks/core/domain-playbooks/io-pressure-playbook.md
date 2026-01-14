# 💽 IO Pressure — Operator Playbook

**Domain:** Block IO, filesystem IO, and storage latency  
**Mental mode:** Latency and queueing, not bandwidth  
**Goal:** Determine whether the system is blocked waiting on storage

---

## 📌 What IO Pressure Actually Means

IO pressure means:

> The system is **waiting on storage** and cannot make forward progress.

This is not about disk “speed”.
This is about:

- Latency
- Queue depth
- Flush and journal stalls
- Blocked tasks that cannot be scheduled

When IO pressure is present:

- Commands hang
- Processes enter `D` (uninterruptible sleep)
- Load average rises but CPU is mostly idle
- The system *feels frozen*

---

## 🔥 Primary Fast Signals

Run these immediately:

    vmstat 1
    iostat -xz 1
    cat /proc/pressure/io
    ps -eo pid,stat,comm | grep ' D '
    uptime

Interpretation:

- `vmstat`:
  - High `b` = blocked processes
  - Low CPU usage + low progress = waiting on IO
- `iostat -xz`:
  - High `await` = latency
  - High `%util` = device saturated
- PSI IO:
  - Non-zero `some` or `full` = tasks stalled on IO
- Processes in `D` state:
  - Cannot be killed
  - Waiting in kernel for IO completion
- Load average:
  - Includes `D` state tasks
  - Can be high even when CPU is idle

---

## 🧠 The Mental Model

The block layer:

- Queues requests
- Submits them to devices
- Waits for completion interrupts

IO pressure exists when:

> Requests **queue faster than the device can complete them**  
> or the device stops responding in a timely manner.

This produces:

- Queue buildup
- Exploding latency
- System-wide stalls

---

## 🧭 Differentiation: IO vs CPU vs Memory

### Looks like IO pressure if:

- Many processes in `D` state
- High `iowait` or low CPU utilization
- Commands hang for seconds or minutes
- PSI IO is non-zero
- `iostat await` is high

### Looks like CPU pressure instead if:

- Processes are in `R` state
- Run queue is high
- CPU is busy
- System is slow but commands return

### Looks like memory pressure instead if:

- You see reclaim activity
- You see swap
- You see kswapd
- You see OOMs

---

## 🧪 Deep Inspection Commands

### Device-level view

    iostat -xz 1
    lsblk
    mount

Look for:
- Which device has high latency
- Which filesystem is involved

### Block queue view

    cat /sys/block/*/queue/nr_requests
    cat /sys/block/*/stat

### Per-process IO

    iotop
    pidstat -d 1

### Hung tasks

    dmesg | grep -i hung

---

## 🧯 Common Root Cause Classes

1. **Device saturation**
   - Too many writers
   - Too many readers
   - Bad query patterns
   - Log storms

2. **Sync / fsync storms**
   - Databases
   - Journaling
   - Containers doing excessive flushes

3. **Journal stalls**
   - ext4, xfs metadata pressure
   - Commit latency spikes

4. **Failing or slow hardware**
   - SSD in bad state
   - Network block device latency
   - USB / SD card stalls

5. **Writeback congestion**
   - Dirty page thresholds exceeded
   - Kernel throttling writers

---

## 🛑 Stabilization Actions (In Order)

1. **Identify the blocking device**

        iostat -xz 1

2. **Find top IO users**

        iotop
        pidstat -d 1

3. **Stop or pause offenders**

        kill -STOP <pid>

4. **Reduce write rate**
   - Disable batch jobs
   - Pause backups
   - Pause compactions
   - Reduce logging

5. **If filesystem or device is unhealthy**
   - Remount read-only if needed
   - Prepare for controlled reboot

---

## ⚠️ Dangerous Misinterpretations

- “Load is high so CPU is the problem”
  - Load includes `D` state tasks.

- “CPU is idle so system should be fast”
  - The kernel is waiting on IO.

- “We just need more CPU”
  - This will not help blocked IO.

---

## 🧨 When IO Pressure Becomes Systemic

You will see:

- SSH hangs
- `ls` hangs
- `ps` hangs
- `systemctl` hangs
- Kubernetes nodes become `NotReady`
- Processes cannot be killed

At this point:

> The kernel is waiting on the storage stack.

---

## 🧱 Escalation Criteria

Escalate or drain the node if:

- Many tasks are stuck in `D` state
- PSI IO `full` is sustained
- Core system commands hang
- You cannot reduce IO load quickly

In Kubernetes:

> Drain the node. This is a storage-path failure.

---

## 🧠 Canonical Summary

- IO pressure = **storage latency and queueing**
- Watch:
  - `D` state tasks
  - PSI IO
  - `iostat await` and `%util`
- High load with low CPU often means **IO**
- Always ask:
  > “What is the kernel waiting on?”

---

## 🧭 This Domain Explains These Scenarios

- “System frozen”
- “Commands hang”
- “Process won’t die”
- “Everything is slow but CPU/mem fine”
- “Node randomly stops responding”

All of these reduce to:

> The kernel is blocked on storage.

---
