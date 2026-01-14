# 🧰 Operator Playbook — Scenario 12: “IO Wait Slowness”

**Primary domain:** IO Pressure  
**Domain playbook:** core/domain-playbooks/io-pressure-playbook.md  
**Why this domain:** The system is blocked waiting on storage, not starved for CPU or memory.

---

## 🎯 The Symptom

- System “feels slow”
- CPU usage is not high
- Memory looks fine
- But:
  - Commands hang
  - SSH feels laggy
  - Services stall
  - Everything waits

Often you’ll hear:

> “The CPU is idle but the system is slow.”

---

## 🧠 The Critical Mental Model

> I/O wait means: **the CPU is idle because tasks are blocked waiting for disk.**

The system is not busy computing.  
It is **waiting on storage**.

---

## 🧪 Phase 1 — Prove It’s I/O Wait

### 1) Check vmstat

    vmstat 1 5

Look at:

- wa = I/O wait
- id = idle CPU

If you see:

- wa high
- id low or medium

Then:

> The CPU is waiting on disk.

---

### 2) Check top / htop

    top

Look for:

- %wa (wa column) being non-zero or high

If:

- %wa > ~5–10% and sustained → **real I/O pressure**

---

## 🧪 Phase 2 — Prove It’s the Disk (Not Network, Not Memory)

### 1) Check memory pressure is not the cause

    free -h
    vmstat 1 5

Confirm:

- si / so = 0
- MemAvailable is healthy

If swap is active → this is **memory pressure**, not pure I/O.

---

### 2) Check PSI (if available)

    cat /proc/pressure/io

Look at:

- some avg10 / avg60 / avg300
- full avg*

Non-zero averages = **tasks are being stalled on I/O**.

---

## 🔍 Phase 3 — Find Which Disk Is Slow

### 1) Check per-disk stats

    iostat -xz 1 5

Look for:

- %util near 100%
- await high
- svctm high
- One device much busier than others

That device is your bottleneck.

---

## 🔥 Phase 4 — Find Which Process Is Causing It

### 1) Use iotop

    sudo iotop

Look for:

- Processes with high DISK READ / WRITE
- Sustained activity, not just spikes

---

### 2) Cross-check with ps

    ps aux | sort -k 6 -n | tail

(Or any tool that shows heavy I/O users.)

---

## 🧱 Phase 5 — Understand the Failure Class

Common causes:

- Log explosion
- Database doing heavy writes
- Backup or rsync job
- Container storage thrashing
- Journal replay
- Disk nearly full → filesystem slow
- Bad disk / slow network storage

---

## 📊 Phase 6 — The Decision Matrix

| What you see | What it means | What you do |
|--------------|---------------|-------------|
| wa high, CPU idle | Disk is the bottleneck | Find I/O hog |
| One disk 100% util | Saturated device | Fix or throttle workload |
| Many writes from one process | Runaway writer | Stop / limit it |
| Disk almost full | Filesystem overhead | Free space |
| iowait + swap | Memory + I/O pressure | Fix memory first |
| PSI(io) non-zero | Real stall | Treat as production incident |

---

## 🛠️ Phase 7 — Typical Fixes

- Stop or reschedule heavy job (backup, scan, index)
- Fix log rotation or runaway logging
- Move workload to faster disk
- Add IOPS / bandwidth
- Add caching
- Fix disk full situation
- Investigate failing disk

---

## ⚠️ Operator Warnings

- High CPU usage ≠ I/O problem
- Low CPU usage ≠ healthy system
- A system can be “idle” and **still unusable** due to I/O wait

---

## 🏁 The Operator Rule

> If CPU is idle but the system is slow, always check **I/O wait**.

---

## 🧠 One-Sentence Operator Summary

> “When a system is slow but CPU and memory look fine, prove whether tasks are blocked on disk using vmstat, PSI, and iostat — then find and stop the I/O hog.”

---

## 🧾 The Minimal Proof Commands

    vmstat 1 5
    top
    cat /proc/pressure/io
    iostat -xz 1 5
    sudo iotop

